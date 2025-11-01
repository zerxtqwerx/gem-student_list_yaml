class StudentBase
    attr_reader :id, :git

    def initialize(id: nil, git: nil)
        @id = id
        @git = git
    end
    def contact
        raise NotImplementedError, "Метод #{__method__} должен быть реализован в подклассе"
    end

    def last_name_initials
        raise NotImplementedError, "Метод #{__method__} должен быть реализован в подклассе"
    end

    def has_git?
        !@git.nil?
    end

    def has_contact?
        raise NotImplementedError, "Метод #{__method__} должен быть реализован в подклассе"
    end
    def to_s
        raise NotImplementedError, "Метод #{__method__} должен быть реализован в подклассе"
    end

    def short_info
        info = []
        info << "ID: #{@id}"        if @id
        info << last_name_initials
        info << contact             if contact
        info << "Git: #{@git}"      if @git
        info.join(", ")
    end
end