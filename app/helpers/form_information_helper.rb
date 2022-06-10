module FormInformationHelper
  def hints(*args)
    args.join('<br>').html_safe
  end

  def character_limit_message(model, attribute)
    "Should be #{configatron.character_limits.send(model).send(attribute)} characters or less."
  end

  def character_limit(model, attribute)
    configatron.character_limits.send(model).send(attribute)
  end
end