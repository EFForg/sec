class FeedbackController < ApplicationController
  invisible_captcha only: :create

  def new
    @feedback = Feedback.new

    SurveyQuestion.order(:position).preload(:options).each do |question|
      @feedback.survey_responses.build(survey_question: question)
    end
  end

  def create
    @feedback = Feedback.create(feedback_params)

    if @feedback.errors.any?
      render "feedback/new"
    else
      redirect_to :feedback_thanks
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
