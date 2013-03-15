#!/usr/bin/env ruby
#
# a capistrano strategy to deploy sub-directory in the repository.
# this is a stuff like "remote_cache_subdir" strategy described in following page,
# but based on "copy" strategy of capistrano deploy recipe.
#
# http://stackoverflow.com/questions/29168/deploying-a-git-subdirectory-in-capistrano
#

require "capistrano"
require "capistrano/recipes/deploy/strategy/copy"
require "capistrano/recipes/deploy/strategy/copy_subdir/version"
require "tmpdir"

module Capistrano
  module Deploy
    module Strategy
      class CopySubdir < Copy
        VERSION = ::Capistrano::Deploy::Strategy::COPY_SUBDIR_VERSION

        def deploy!
          update_repository_cache
          copy_repository_cache
          distribute!
        ensure
          FileUtils.rm filename rescue nil
          FileUtils.rm_rf destination rescue nil
          FileUtils.rm_rf repository_cache rescue nil if remove_repository_cache?
        end

        private

        def update_repository_cache
          if File.exists?(repository_cache)
            logger.debug "refreshing local cache to revision #{revision} at #{repository_cache}"
            system(source.sync(revision, repository_cache))
          else
            logger.debug "preparing local cache at #{repository_cache}"
            system(source.checkout(revision, repository_cache))
          end

          # Check the return code of last system command and rollback if not 0
          unless $? == 0
            raise Capistrano::Error, "shell command failed with return code #{$?}"
          end
        end

        def copy_repository_cache
          logger.debug "copying cache from #{repository_cache_subdir} to deployment staging area #{destination}"
          if copy_exclude.empty?
            run_locally "cp -RPp #{repository_cache_subdir} #{destination} && #{mark}"
          else
            exclusions = copy_exclude.map { |e| "--exclude=\"#{e}\"" }.join(' ')
            run_locally "rsync -lrpt #{exclusions} #{repository_cache_subdir}/ #{destination} && #{mark}"
          end

          logger.trace "compressing #{destination} to #{filename}"
          Dir.chdir(copy_dir) { system(compress(File.basename(destination), File.basename(filename)).join(" ")) }
        end

        # Returns the command which will write the identifier of the
        # revision being deployed to the REVISION file on each host.
        def mark
          "(echo #{revision} > #{destination}/REVISION)"
        end

        # Remote filename should be differ from local filename to allow deploy to localhost.
        def remote_filename
          @remote_filename ||= File.join(remote_dir, "copy-#{File.basename(destination)}.#{compression.extension}")
        end

        # Local repository path.
        def repository_cache
          @repository_cache ||= copy_cache || Dir.mktmpdir('cached-copy', copy_dir) { |dir| dir }
        end

        # Deploy subtree specified as :deploy_subdir in local repository.
        def repository_cache_subdir
          @repository_cache_subdir ||= if configuration[:deploy_subdir] then
                                         File.join(repository_cache, configuration[:deploy_subdir])
                                       else
                                         repository_cache
                                       end
        end

        # Remove local repository cache if :copy_cache is not enabled.
        def remove_repository_cache?
          !copy_cache
        end
      end
    end
  end
end

# vim:set ft=ruby :
