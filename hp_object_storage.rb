
require 'rubygems'
require 'fog'


OS_STORAGE_AUTH_URL         = ENV['OS_STORAGE_AUTH_URL']
OS_STORAGE_ACCOUNT_ID       = ENV['OS_STORAGE_ACCOUNT_ID']
OS_STORAGE_SECRET_KEY       = ENV['OS_STORAGE_SECRET_KEY']
OS_STORAGE_TENANT_ID        = ENV['OS_STORAGE_TENANT_ID']
OS_STORAGE_AVL_ZONE         = ENV['OS_STORAGE_AVL_ZONE']

class HPObjectStorage

  def initialize
    @connection ||= Fog::Storage.new( :provider      => 'HP',
                          :hp_account_id => OS_STORAGE_ACCOUNT_ID,
                          :hp_secret_key => OS_STORAGE_SECRET_KEY,
                          :hp_tenant_id => OS_STORAGE_TENANT_ID,
                          :hp_auth_uri   => OS_STORAGE_AUTH_URL,
                          :hp_use_upass_auth_style =>"true"
                           )
  end

  def directories
    @connection.directories
  end

  def calendar_dir
    @connection.directories.get("calendar")
  end

  def calendar_file
    calendar_dir.files.get("calendar.json")
  end

  def calendar_list
    calendar_dir.files.get("calendar_list.json")
  end

  def update_calendar_file(content)
    calendar_dir.files.create(:key => "calendar.json", :body => content)
  end

  def update_calendar_list(content)
     calendar_dir.files.create(:key => "calendar_list.json", :body => content)
   end

  def tasks_dir
    @connection.directories.get("omnifocus")
  end

  def tasks_file
    tasks_dir.files.get("tasks.json")
  end

  def update_tasks_file(content)
      tasks_dir.files.create(:key=>"tasks.json", :body=>content)
  end

end