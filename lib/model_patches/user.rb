  User.class_eval do
    before_validation :sanitize_telephone_number
    validate :telephone_number_validations

    private

    def sanitize_telephone_number
      return if !telephone_number

      # Remove all whitespace
      sanitized = telephone_number.gsub(/\s+|-/, "")

      # Remove leading country number if present
      sanitized = sanitized.sub(/^((?:\+|00)310?)/, "0")

      # First character should be 0 now
      if sanitized =~ /^0/
        sanitized = sanitized[1..-1]
      end

      # Add +31
      self.telephone_number = "+31#{sanitized}"
    end

    def telephone_number_validations
      return unless telephone_number

      if telephone_number.length != 12
        errors.add(:telephone_number, "should be a Dutch number consisting of 10 digits")
        return
      end

      if telephone_number !~ /\+31[0-9]{9}/
        errors.add(:telephone_number, "should only contain digits")
        return
      end
    end

  end
