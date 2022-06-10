class CodeGenerator
  attr_reader :count, :codes

  def self.call(count)
    new(count).call
  end

  def initialize(count)
    @count = count
    @codes = []
  end

  def call
    generate_codes while codes_left_to_generate?
    codes
  end

  protected

  def codes_left_to_generate?
    codes_left_to_generate > 0
  end

  def codes_left_to_generate
    count - codes.length
  end

  def generate_codes
    push_new_codes
    reject_codes_already_taken!
  end

  def push_new_codes
    new_codes = []
    codes_left_to_generate.times { new_codes << KeyGenerator.generate(code_salt, code_length) }
    @codes += new_codes.uniq
  end

  def reject_codes_already_taken!
    check_for_codes_already_taken
    codes.delete_if { |c| codes_already_token.include?(c) }
  end

  def check_for_codes_already_taken
    @codes_already_taken = duplicate_query_class.call(codes)
  end

  def codes_already_token
    @codes_already_taken
  end

  def duplicate_query_class
    raise Chippd::ImplementInSubclassError
  end

  def code_length
    raise Chippd::ImplementInSubclassError
  end

  def code_salt
    raise Chippd::ImplementInSubclassError
  end
end
