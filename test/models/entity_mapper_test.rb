require 'test_helper'

class EntityMapperTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test '#find_mappings creates a new grade' do
    mapper = GradeMapper.new(repository: @repo)

    assert_difference 'Grade.count', +1 do
      grade = mapper.find_mappings('test grade')[0]
      assert_equal 'test grade', grade.name
    end
  end

  test '#find_mappings finds existing grade' do
    mapper = GradeMapper.new(repository: @repo)

    assert_no_difference 'Grade.count' do
      grade = mapper.find_mappings('grade 1')[0]
      assert_equal 'grade 1', grade.name
    end
  end

  test '#find_mappings reuses grade mapping' do
    mapper = GradeMapper.new(repository: @repo)

    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Grade.count' do
        grade = mapper.find_mappings('grade 1')[0]
        assert_equal 'grade 1', grade.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      mapper.find_mappings('grade 1')
    end
  end

  test '#find_mappings creates a new language' do
    mapper = LanguageMapper.new(repository: @repo)

    assert_difference 'Language.count', +1 do
      language = mapper.find_mappings('ko')[0]
      assert_equal 'ko', language.name
    end
  end

  test '#find_mappings finds existing language' do
    mapper = LanguageMapper.new(repository: @repo)

    assert_no_difference 'Language.count' do
      language = mapper.find_mappings('en')[0]
      assert_equal 'en', language.name
    end
  end

  test '#find_mappings reuses language mapping' do
    mapper = LanguageMapper.new(repository: @repo)

    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Language.count' do
        language = mapper.find_mappings('en')[0]
        assert_equal 'en', language.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      mapper.find_mappings('en')
    end
  end

  test '#find_mappings creates a new publisher' do
    mapper = IdentityMapper.new(repository: @repo)

    assert_difference 'Identity.count', +1 do
      publisher = mapper.find_mappings('test publisher')[0]
      assert_equal 'test publisher', publisher.name
    end
  end

  test '#find_mappings finds existing publisher' do
    mapper = IdentityMapper.new(repository: @repo)

    assert_no_difference 'Identity.count' do
      publisher = mapper.find_mappings('Khan Academy')[0]
      assert_equal 'Khan Academy', publisher.name
    end
  end

  test '#find_mappings reuses publisher mapping' do
    mapper = IdentityMapper.new(repository: @repo)

    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Identity.count' do
        publisher = mapper.find_mappings('Khan Academy')[0]
        assert_equal 'Khan Academy', publisher.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      mapper.find_mappings('Khan Academy')
    end
  end

  test '#find_mappings creates a new resource_type' do
    mapper = ResourceTypeMapper.new(repository: @repo)

    assert_difference 'ResourceType.count', +1 do
      resource_type = mapper.find_mappings('test resource_type')[0]
      assert_equal 'test resource_type', resource_type.name
    end
  end

  test '#find_mappings finds existing resource_type' do
    mapper = ResourceTypeMapper.new(repository: @repo)

    assert_no_difference 'ResourceType.count' do
      resource_type = mapper.find_mappings('lesson')[0]
      assert_equal 'lesson', resource_type.name
    end
  end

  test '#find_mappings reuses resource_type mapping' do
    mapper = ResourceTypeMapper.new(repository: @repo)

    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'ResourceType.count' do
        resource_type = mapper.find_mappings('lesson')[0]
        assert_equal 'lesson', resource_type.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      mapper.find_mappings('lesson')
    end
  end

  test '#find_mappings creates a new subject' do
    mapper = SubjectMapper.new(repository: @repo)

    assert_difference 'Subject.count', +1 do
      subject = mapper.find_mappings('test subject')[0]
      assert_equal 'test subject', subject.name
    end
  end

  test '#find_mappings finds existing subject' do
    mapper = SubjectMapper.new(repository: @repo)

    assert_no_difference 'Subject.count' do
      subject = mapper.find_mappings('history')[0]
      assert_equal 'history', subject.name
    end
  end

  test '#find_mappings reuses subject mapping' do
    mapper = SubjectMapper.new(repository: @repo)

    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Subject.count' do
        subject = mapper.find_mappings('history')[0]
        assert_equal 'history', subject.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      mapper.find_mappings('history')
    end
  end

  test '#find_mappings creates a new standard' do
    mapper = StandardMapper.new(repository: @repo)

    assert_difference 'Standard.count', +1 do
      standard = mapper.find_mappings('test standard')[0]
      assert_equal 'test standard', standard.name
    end
  end

  test '#find_mappings finds existing standard' do
    mapper = StandardMapper.new(repository: @repo)

    assert_no_difference 'Standard.count' do
      standard = mapper.find_mappings('ccls.1.2')[0]
      assert_equal 'ccls.1.2', standard.name
    end
  end

  test '#find_mappings reuses standard mapping' do
    mapper = StandardMapper.new(repository: @repo)

    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Standard.count' do
        standard = mapper.find_mappings('ccls.1.2')[0]
        assert_equal 'ccls.1.2', standard.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      mapper.find_mappings('ccls.1.2')
    end
  end

  test '#find_mappings creates a new url' do
    mapper = UrlMapper.new(repository: @repo)

    assert_difference 'Url.count', +1 do
      url = mapper.find_mappings('http://www.test.com')[0]
      assert_equal 'http://www.test.com', url.url
    end
  end

  test '#find_mappings finds existing url' do
    mapper = UrlMapper.new(repository: @repo)

    khan = urls(:khan_intro_algebra).url

    assert_no_difference 'Url.count' do
      url = mapper.find_mappings(khan)[0]
      assert_equal khan, url.url
    end
  end

  test '#find_mappings reuses url mapping' do
    mapper = UrlMapper.new(repository: @repo)

    khan = urls(:khan_intro_algebra).url

    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Url.count' do
        url = mapper.find_mappings(khan)[0]
        assert_equal khan, url.url
      end
    end

    assert_no_difference 'ValueMapping.count' do
      mapper.find_mappings(khan)
    end
  end
end
