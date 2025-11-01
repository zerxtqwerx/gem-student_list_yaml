require_relative 'student_base'
require_relative 'student'

class StudentShort < StudentBase
  attr_reader :initials, :contact

  def initialize(id:, initials:, contact: nil, git: nil)
    super(id: id, git: git)
    validate_required(id: id, initials: initials)
    @initials = initials
    @contact = contact
  end
  
  def self.from_student(student)
    initials = student.last_name_initials
    contact = student.contact
    validate_required(id: id, initials: initials)
    new(id: student.id, initials: initials, contact: contact, git: student.git)
  end

  def last_name_initials
    @initials
  end

  def has_contact?
    !@contact.nil?
  end

  def to_s
    short_info
  end

  private
  def validate_required(fields)
    fields.each do |field_name, value|
      raise ArgumentError, "Поле '#{field_name}' обязательно" if value.nil? || value.to_s.strip.empty?
    end
  end
end