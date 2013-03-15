set :application, "capistrano-copy-subdir"
set :repository,  "."
set :deploy_to do
  File.join("/home", user, application)
end
set :deploy_via, :copy
set :scm, :none
set :use_sudo, false
set :user, "vagrant"
set :password, "vagrant"
set :ssh_options, {:user_known_hosts_file => "/dev/null"}

role :web, "192.168.33.10"
role :app, "192.168.33.10"
role :db,  "192.168.33.10", :primary => true

$LOAD_PATH.push(File.expand_path("../../lib", File.dirname(__FILE__)))
require "tempfile"

def assert_file_exists(file, options={})
  begin
    invoke_command("test -f #{file.dump}", options)
  rescue
    logger.debug("assert_file_exists(#{file}) failed.")
    invoke_command("ls #{File.dirname(file).dump}", options)
    raise
  end
end

def assert_file_content(file, content, options={})
  begin
    tempfile = Tempfile.new("tmp")
    download(file, tempfile.path)
    remote_content = tempfile.read
    abort if content != remote_content
  rescue
    logger.info("assert_file_content(#{file}, #{content.dump}) failed.")
    raise
  end
end

task(:test_all) {
  find_and_execute_task("test_default")
  find_and_execute_task("test_with_subdir")
}

namespace(:test_default) {
  task(:default) {
    methods.grep(/^test_/).each do |m|
      send(m)
    end
  }
  before "test_default", "test_default:setup"
  after "test_default", "test_default:teardown"

  task(:setup) {
    set(:deploy_via, :copy_subdir)
    set(:deploy_subdir, nil)
    reset!(:strategy)
    find_and_execute_task("deploy:setup")
  }

  task(:teardown) {
    run("rm -rf #{deploy_to.dump}")
  }

  task(:test_deploy) {
    find_and_execute_task("deploy")
    # check if files in current directory has been deployed?
    assert_file_exists(File.join(current_path, "Capfile"))
    assert_file_exists(File.join(current_path, "Vagrantfile"))
    assert_file_content(File.join(current_path, "Capfile"), File.read("Capfile"))
    assert_file_content(File.join(current_path, "Vagrantfile"), File.read("Vagrantfile"))
  }
}

namespace(:test_with_subdir) {
  task(:default) {
    methods.grep(/^test_/).each do |m|
      send(m)
    end
  }
  before "test_with_subdir", "test_with_subdir:setup"
  after "test_with_subdir", "test_with_subdir:teardown"

  task(:setup) {
    run_locally("mkdir -p tmp/copy_subdir")
    set(:deploy_via, :copy_subdir)
    set(:deploy_subdir, "tmp/copy_subdir")
    reset!(:strategy)
    find_and_execute_task("deploy:setup")
  }

  task(:teardown) {
    run_locally("rm -rf tmp/copy_subdir")
    run("rm -rf #{deploy_to.dump}")
  }

  task(:test_deploy) {
    run_locally("echo foo > tmp/copy_subdir/foo")
    run_locally("echo bar > tmp/copy_subdir/bar")
    find_and_execute_task("deploy")
    # check if files in sub directory has been deployed?
    assert_file_exists(File.join(current_path, "foo"))
    assert_file_exists(File.join(current_path, "bar"))
    assert_file_content(File.join(current_path, "foo"), File.read("tmp/copy_subdir/foo"))
    assert_file_content(File.join(current_path, "bar"), File.read("tmp/copy_subdir/bar"))
  }

  task(:test_redeploy) {
    run_locally("echo bar > tmp/copy_subdir/foo")
    run_locally("echo foo > tmp/copy_subdir/bar")
    find_and_execute_task("deploy")
    # check again if files in sub directory has been deployed?
    assert_file_exists(File.join(current_path, "foo"))
    assert_file_exists(File.join(current_path, "bar"))
    assert_file_content(File.join(current_path, "foo"), File.read("tmp/copy_subdir/foo"))
    assert_file_content(File.join(current_path, "bar"), File.read("tmp/copy_subdir/bar"))
  }
}

# vim:set ft=ruby sw=2 ts=2 :
