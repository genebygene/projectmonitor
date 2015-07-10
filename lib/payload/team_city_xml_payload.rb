class TeamCityXmlPayload < Payload

  def initialize(project)
    super()
    @project = project
  end

  def building?
    status_content.first.attribute('running').present?
  end

  def build_status_is_processable?
    status_is_processable?
  end

  private

  def content_ready?(content)
    return false if content.attribute('running').present? && content.attribute('status').value != 'FAILURE'
    return false if content.attribute('status').value == 'UNKNOWN'
    true
  end

  def convert_content!(raw_content)
    Array.wrap(convert_xml_content!(raw_content, true).css('build'))
  end

  def convert_tests_content!(raw_content)
    if raw_content.present?
      Array.wrap(convert_xml_content!(raw_content, true).css('testOccurrence'))
    else
      []
    end
  end

  def parse_success(content)
    content.attribute('status').value == 'SUCCESS'
  end

  def parse_url(content)
    content.attribute('webUrl').value
  end

  def parse_build_id(content)
    content.attribute('id').value
  end

  def parse_published_at(content)
    parse_start_date_attribute(content.attribute('startDate'))
  end

  def parse_tests_status(content)

    build_id      = parse_build_id(content)
    test_build_id = nil
    match         = false

    status_map = {
      'SUCCESS' => 'p',
      'FAILURE' => 'f',
      'UNKNOWN' => 's'
    }

    results = {}
    tests_status_content.each do |test|

      unless test_build_id
        id = test.attributes['id'].value
        test_build_id = id.match(/build:\(id:(\d+)\)/).captures.first
        break unless test_build_id == build_id
        match = true
      end

      status = test.attributes['status'].value
      if results.key?(status)
        results[status] += 1
      else
        results[status] = 1
      end
    end

    if match
      results.map{|k,v| "#{v}#{status_map[k]}"}.join(' ')
    else
      nil
    end
  end

  def parse_start_date_attribute(start_date_attribute)
    if start_date_attribute.present?
      Time.parse(start_date_attribute.value).localtime
    else
      Time.now.localtime
    end
  end
end
