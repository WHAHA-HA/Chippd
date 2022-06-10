class CodeValueGenerator < CodeGenerator
  protected

  def duplicate_query_class
    DuplicateCodeValueQuery
  end

  def code_length
    5
  end

  def code_salt
    "f61317de12323202f28e4747fdcb5d5c28bcfe26ded318d5e3fecb8b4bb94248d33b515adfe2720035e2f85c1f220c8ec3b83fcf82d1b84ac8a818526c152232"
  end
end
