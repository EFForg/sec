module FeedbackHelper
  def survey_prompt(question)
    content_tag(:span, class: question.required? ? "required" : "") do
      question.prompt.strip.tap do |prompt|
        prompt << ":" unless prompt =~ /[.?!:]$/
      end
    end
  end

  def survey_response_histogram(question)
    table = question.options.order(:position).map do |option|
      [option.value, question.responses.where(value: option.value).count]
    end.to_h

    total = table.values.sum
    table.map do |option, count|
      data = OpenStruct.new(
        count: count,
        percentage: 100.0 * count / total,
        frequent?: table.values.all?{ |v| v <= count }
      )
      [option, data]
    end.to_h
  end

  def quick_feedback_responses
    SurveyQuestion.by_survey(Feedback::QUICK_SURVEY)
      .map{ |q| q.responses.build }
  end

  def cache_key_for_quick_survey
    # SurveyQuestion.where(survey: Feedback::QUICK_SURVEY).cache_key

    # Let's just clear the cache whenever it changes...
    "quick-survey"
  end
end
