class FeedbackController < ApplicationController
  def new
    @feedback = Feedback.new

    SurveyQuestion.order(:position).preload(:options).each do |question|
      @feedback.survey_responses.build(survey_question: question)
    end
  end

  def create
    if @feedback = Feedback.create(feedback_params)
      redirect_to :feedback_thanks
    else
      render "new"
    end
  end

  def thanks
  end

  private

  def feedback_params
    params.require(:feedback).
      permit(survey_responses_attributes: [:survey_question_id, :value])
  end
end
