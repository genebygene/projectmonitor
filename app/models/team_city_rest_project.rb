class TeamCityRestProject < Project

  validates_presence_of :ci_build_identifier, :ci_base_url, unless: ->(project) { project.webhooks_enabled }

  alias_attribute :build_status_url, :feed_url
  alias_attribute :project_name, :feed_url

  def feed_url
    # Only Master branch
    # url_with_scheme "#{ci_base_url}/app/rest/builds?locator=running:all,buildType:(id:#{ci_build_identifier}),personal:false"

    # Any branch
    url_with_scheme "#{ci_base_url}/app/rest/builds?locator=running:all,buildType:(id:#{ci_build_identifier}),personal:false,branch(default:any)"
  end

  def build_tests_status_url(build_id)
    url_with_scheme "#{ci_base_url}/app/rest/testOccurrences?locator=build:#{build_id},count:999999"
  end

  def query_tests_results?
    true
  end


  def fetch_payload
    TeamCityXmlPayload.new(self)
  end

  def webhook_payload
    TeamCityJsonPayload.new
  end

  def has_dependencies?
    true
  end

end
