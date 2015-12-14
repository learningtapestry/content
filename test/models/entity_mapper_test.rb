require 'test_helper'

class EntityMapperTest < ActiveSupport::TestCase
  test '#find_grades creates a new grade' do
    mapper = EntityMapper.new

    assert_difference 'Grade.count', +1 do
      grade = mapper.find_grades('test grade')[0]
      assert_equal 'test grade', grade.value
    end
  end

  test '#find_grades finds existing grade' do
    mapper = EntityMapper.new

    assert_no_difference 'Grade.count' do
      grade = mapper.find_grades('grade 1')[0]
      assert_equal 'grade 1', grade.value
    end
  end

  test '#find_languages creates a new language' do
    mapper = EntityMapper.new

    assert_difference 'Language.count', +1 do
      language = mapper.find_languages('ko')[0]
      assert_equal 'ko', language.value
    end
  end

  test '#find_languages finds existing language' do
    mapper = EntityMapper.new

    assert_no_difference 'Language.count' do
      language = mapper.find_languages('en')[0]
      assert_equal 'en', language.value
    end
  end

  test '#find_publishers creates a new publisher' do
    mapper = EntityMapper.new

    assert_difference 'Identity.count', +1 do
      publisher = mapper.find_publishers('test publisher')[0]
      assert_equal 'test publisher', publisher.value
    end
  end

  test '#find_publishers finds existing publisher' do
    mapper = EntityMapper.new

    assert_no_difference 'Identity.count' do
      publisher = mapper.find_publishers('khan')[0]
      assert_equal 'khan', publisher.value
    end
  end

  test '#find_resource_types creates a new resource_type' do
    mapper = EntityMapper.new

    assert_difference 'ResourceType.count', +1 do
      resource_type = mapper.find_resource_types('test resource_type')[0]
      assert_equal 'test resource_type', resource_type.value
    end
  end

  test '#find_resource_types finds existing resource_type' do
    mapper = EntityMapper.new

    assert_no_difference 'ResourceType.count' do
      resource_type = mapper.find_resource_types('lesson')[0]
      assert_equal 'lesson', resource_type.value
    end
  end

  test '#find_subjects creates a new subject' do
    mapper = EntityMapper.new

    assert_difference 'Subject.count', +1 do
      subject = mapper.find_subjects('test subject')[0]
      assert_equal 'test subject', subject.value
    end
  end

  test '#find_subjects finds existing subject' do
    mapper = EntityMapper.new

    assert_no_difference 'Subject.count' do
      subject = mapper.find_subjects('history')[0]
      assert_equal 'history', subject.value
    end
  end

  test '#find_standards creates a new standard' do
    mapper = EntityMapper.new

    assert_difference 'Standard.count', +1 do
      standard = mapper.find_standards('test standard')[0]
      assert_equal 'test standard', standard.value
    end
  end

  test '#find_standards finds existing standard' do
    mapper = EntityMapper.new

    assert_no_difference 'Standard.count' do
      standard = mapper.find_standards('ccls.1.2')[0]
      assert_equal 'ccls.1.2', standard.value
    end
  end

  test '#find_urls creates a new url' do
    mapper = EntityMapper.new

    assert_difference 'Url.count', +1 do
      url = mapper.find_urls('http://www.test.com')[0]
      assert_equal 'http://www.test.com', url.url
    end
  end

  test '#find_urls finds existing url' do
    mapper = EntityMapper.new

    khan = urls(:khan_intro_algebra).url

    assert_no_difference 'Url.count' do
      url = mapper.find_urls(khan)[0]
      assert_equal khan, url.url
    end
  end
end
