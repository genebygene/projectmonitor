class TeamCityJsonPayload < Payload

  def building?
    content = build_status_content.first || status_content.first

    content['buildResult'] == 'running' && content['notifyType'] == 'buildStarted'
  end

  def convert_content!(raw_content)
    convert_json_content!(raw_content)
  end

  def convert_webhook_content!(params)
    Array.wrap(params['build'])
  end

  def content_ready?(content)
    content['buildResult'] != 'running'
  end

  def parse_success(content)
    content['buildResult'] == 'success'
  end

  def parse_url(content)
    if content['buildStatusUrl']
      self.parsed_url = content['buildStatusUrl']
    else
      self.parsed_url = "http://#{remote_addr}:8111/viewType.html?buildTypeId=#{parse_build_type_id(content)}"
      "http://#{remote_addr}:8111/viewLog.html?buildId=#{parse_build_id(content)}&tab=buildResultsDiv&buildTypeId=#{parse_build_type_id(content)}"
    end
  end

  def parse_build_type_id(content)
    content['buildTypeId']
  end

  def parse_build_id(content)
    content['buildId']
  end

  def parse_published_at(content)
    Time.now
  end

  def parse_tests_status(content)
    'Parsed Test Status'
  end

end
