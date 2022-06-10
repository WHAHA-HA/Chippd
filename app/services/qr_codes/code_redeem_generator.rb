class CodeRedeemGenerator < CodeGenerator
  protected

  def duplicate_query_class
    DuplicateCodeRedeemQuery
  end

  def code_length
    8
  end

  def code_salt
    "7923d06573f9b2ec27dc7ac62a1167df55117357304bb71d995f36d467a226479f1fb37257d1dc4552aa06f018d2a59499d3bfd15d3c5b60797858587c5ed3e5"
  end
end
