module FeedbackHelper
  def survey_prompt(question)
    question.prompt.strip.tap do |prompt|
      prompt << ":" unless prompt =~ /[.?!:]$/
      prompt << "*" if question.required?
    end
  end
end
