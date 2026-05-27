User.class_eval do
  before_validation :sanitize_telephone_number
  validate :telephone_number_validations
  after_save :add_telephone_number_censor_rule

  def telephone_number_provided?
    !telephone_number.blank?
  end

  def display_telephone_number
    return "" if !telephone_number_provided?
    telephone_number.sub(/^\+31/, '0')
  end

  private

  def sanitize_telephone_number
    return if !telephone_number

    # Remove all whitespace
    sanitized = telephone_number.gsub(/\s+|-/, "")
    return unless telephone_number_provided?

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
    return unless telephone_number_provided?

    if telephone_number.length != 12
      errors.add(:telephone_number, _("should be a Dutch number consisting of 10 digits"))
      return
    end

    if telephone_number !~ /\+31[0-9]{9}/
      errors.add(:telephone_number, _("should only contain digits"))
      return
    end
  end

  def add_telephone_number_censor_rule
    return if !telephone_number_provided?

    regexp = "#{telephone_number}|#{display_telephone_number}".gsub("+", "\\\\+")
    return if censor_rules.where(["text = ?", regexp]).exists?

    CensorRule.create!(
      user_id: id,
      text: regexp,
      replacement: _("[removed]"),
      last_edit_editor: THEME_NAME,
      last_edit_comment: _("Created automatically after saving user"),
      regexp: true
    )
  end

end
