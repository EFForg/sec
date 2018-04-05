class FeedbackController < ApplicationController
  invisible_captcha only: :create

  skip_before_action :verify_authenticity_token
  before_action :verify_request_origin

  def new
    @feedback = Feedback.new

    survey_questions.each do |question|
      @feedback.survey_responses.build(survey_question: question)
    end
  end

  def create
    @feedback = Feedback.create(feedback_params)

    if @feedback.errors.any?
      render "feedback/new"
    else
      respond_to do |format|
        format.html{ redirect_to :feedback_thanks }
        format.js
      end
    end
  end

  def thanks
  end

  private

  def feedback_params
    params.require(:feedback).
      permit(
        :mobile,
        survey_responses_attributes: [:survey_question_id, :value]
      ).
      merge(source_url: request.referrer)
  end

  def survey_questions
    SurveyQuestion.by_survey(Feedback::LONG_SURVEY)
  end
end
