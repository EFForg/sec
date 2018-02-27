module FeedbackHelper
  def survey_prompt(question)
    question.prompt.strip.tap do |prompt|
      prompt << ":" unless prompt =~ /[.?!:]$/
      prompt << "*" if question.required?
    end
  end

  def quick_feedback
    Feedback.new.tap do |feedback|
      questions = SurveyQuestion.
        where(survey: "quick").
        order(:position).
        preload(:options)

      questions.each do |question|
        feedback.survey_responses.build(survey_question: question)
      end
    end
  end
end
