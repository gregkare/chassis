require_relative 'test_helper'

class DirtySessionTest < MiniTest::Unit::TestCase
  class Person
    include Chassis::Initializable

    attr_accessor :name, :email, :id
  end

  attr_reader :person

  def setup
    @person = Person.new do |person|
      person.name = 'adam'
      person.email = 'example@example.com'
      person.id = 1
    end
  end

  def test_initialize_as_clean
    session = Chassis::DirtySession.new person
    assert session.clean?
    refute session.dirty?
  end

  def test_assigning_new_value_marks_the_session_dirty
    session = Chassis::DirtySession.new person
    session.name = 'foo'

    refute session.clean?
    assert session.dirty?
  end

  def test_changes_can_be_tested_via_query_method
    session = Chassis::DirtySession.new person
    session.name = 'foo'

    refute session.clean?
    assert session.dirty?

    assert_respond_to session, :name_changed?, "Session should respond to changed queries"
    assert session.name_changed?
  end

  def test_changes_include_all_new_assignments
    session = Chassis::DirtySession.new person
    session.name = 'foo'

    refute session.clean?
    assert session.dirty?

    assert_equal(Set.new([:name]), session.changes)
  end

  def test_changes_are_accessible
    session = Chassis::DirtySession.new person
    session.name = 'foo'

    refute session.clean?
    assert session.dirty?

    assert_equal({ name: 'foo' }, session.new_values)
  end

  def test_assigning_a_new_value_records_the_original_value
    original_name = person.name
    assert original_name, "Precondition: person must have a name"

    session = Chassis::DirtySession.new person
    session.name = 'foo'

    refute session.clean?
    assert session.dirty?

    assert_equal({ name: original_name}, session.original_values)
  end

  def test_original_values_are_accessible_via_an_original_method
    original_name = person.name
    assert original_name, "Precondition: person must have a name"

    session = Chassis::DirtySession.new person
    session.name = 'foo'

    refute session.clean?
    assert session.dirty?

    assert_respond_to session, :original_name, "Session should respond to original_XXX methods"
    assert_equal original_name, session.original_name
  end
end
