require_relative "student_base"
require_relative "custom_setter.rb"

class Student < StudentBase
  include Comparable
  extend ValidationSetter 

  NAME_REGEX = /\A[a-zA-Zа-яА-ЯёЁ]+(?:[-\s][a-zA-Zа-яА-ЯёЁ]+)*\z/
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  PHONE_REGEX = /\A\+?[\d\s\-\(\)]{10,}\z/
  GIT_REGEX = %r{\Ahttps://github\.com/[\w\-]+\z}
  TELEGRAM_REGEX = /\A@[\w]+\z/

  CONTACTS = [:telegram, :email, :phone].freeze

  attr_with_validation :last_name, :name, :required
  attr_with_validation :first_name, :name, :required
  attr_with_validation :patronymic, :name, :optional
  attr_with_validation :phone, :phone, :optional
  attr_with_validation :telegram, :phone, :optional
  attr_with_validation :email, :email, :optional
  attr_with_validation :git, :git, :optional

  def initialize(last_name:, first_name:, patronymic: nil, id: nil, phone: nil, telegram: nil, email: nil, git: nil)
    super(id: id, git: git)
    
    self.last_name = last_name
    self.first_name = first_name
    self.patronymic = patronymic
    self.phone = phone
    self.telegram = telegram
    self.email = email
  end

  def self.valid_name?(name)
    return false if name.nil? || name.strip.empty?
    name.match?(NAME_REGEX)
  end

  def self.valid_phone?(phone)
    return true if phone.nil? || phone.strip.empty?
    phone.match?(PHONE_REGEX)
  end

  def self.valid_email?(email)
    return true if email.nil? || email.strip.empty?
    email.match?(EMAIL_REGEX)
  end

  def self.valid_telegram?(telegram)
    return true if telegram.nil? || telegram.strip.empty?
    telegram.match?(TELEGRAM_REGEX)
  end

  def self.valid_git?(git)
    return true if git.nil? || git.strip.empty?
    git.match?(GIT_REGEX)
  end

  def contact
    CONTACTS.find { |contact| send(contact) }
  end

  def last_name_initials
    initials = ["#{@last_name} #{@first_name[0]}."]
    initials << "#{@patronymic[0]}." if @patronymic
    initials.join(" ")
  end

  def has_contact?
    CONTACTS.any? { |contact| send(contact) }
  end

  def to_s
    info = []
    info << "ID: #{@id}"                if @id
    info << "Фамилия: #{@last_name}"
    info << "Имя: #{@first_name}"
    info << "Отчество: #{@patronymic}"  if @patronymic
    info << "Телефон: #{@phone}"        if @phone
    info << "Email: #{@email}"          if @email
    info << "Telegram: #{@telegram}"    if @telegram
    info << "Git: #{@git}"              if @git
    info.join(", ")
  end

  def <=>(other)
    return nil unless other.is_a?(Student)
    
    [last_name, first_name, patronymic.to_s, git.to_s] <=>
    [other.last_name, other.first_name, other.patronymic.to_s, other.git.to_s]
  end

  private

  def validate_required(field_name, value)
    return value if self.class.send("valid_#{field_name}?", value)
    
    case field_name
    when :last_name, :first_name
      raise ArgumentError, "Экземпляр #{last_name_initials}. Поле #{field_name} не может быть пустым"
    else
      raise ArgumentError, "Экземпляр #{last_name_initials}. Поле #{field_name} имеет неверный формат"
    end
  end

  def validate_optional(field_name, value)
    return nil if value.nil? || value.strip.empty?
    
    if self.class.send("valid_#{field_name}?", value)
      value
    else
      puts "Предупреждение: Экземпляр #{last_name_initials}. Поле #{field_name} имеет неверный формат"
      nil
    end
  end
end