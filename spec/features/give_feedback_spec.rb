require 'rails_helper'

RSpec.feature "GiveFeedback", type: :feature, js: true do
  let(:article) { FactoryGirl.create(:article) }

  let(:quick_questions) {
    SurveyQuestion.where(survey: Feedback::QUICK_SURVEY)
  }

  let(:survey_questions) {
    SurveyQuestion.where(survey: Feedback::LONG_SURVEY)
  }

  before do
    quick_questions.create(
      prompt: "Did you find what you were looking for?",
      options_attributes: [{ value: "Yes" },
                           { value: "Partially" },
                           { value: "No" }]
    )

    quick_questions.create(prompt: "Any comments?")

    survey_questions.create(
      prompt: "What is your overall impression?",
      options_attributes: [{ value: "Satisfied" },
                           { value: "Neutral" },
                           { value: "Dissatisfied" }],
      required: true
    )

    survey_questions.create(
      prompt: "What best describes your affiliation?"
    )
  end

  scenario "user fills in the quick feedback form" do
    # Remove once surveys become live.
    login(FactoryGirl.create(:admin_user))

    visit article_path(article)
    source_url = current_url

    click_on("Feedback")

    within(:css, ".quick-feedback") do
      find(:css, "label[for=feedback_survey_responses_attributes_0_value_partially]").click
      find(:css, "textarea").send_keys("These are my comments.")

      expect {
        click_on("Send feedback")
        has_css?("#new_feedback.success")
      }.to change(Feedback, :count).by(1)

      feedback = Feedback.order(id: :desc).take
      expect(feedback.survey_responses.pluck(:value)).
        to eq(["Partially", "These are my comments."])

      expect(feedback.source_url).to eq(source_url)
    end
  end

  scenario "user fills in the long feedback form" do
    visit feedback_root_path
    source_url = current_url

    choose "Neutral"
    find(:css, "textarea").send_keys("I am a teacher.")

    expect {
      click_on("Submit")
      has_current_path?(feedback_thanks_path)
    }.to change(Feedback, :count).by(1)

    feedback = Feedback.order(id: :desc).take

    expect(feedback.survey_responses.pluck(:value)).
      to eq(["Neutral", "I am a teacher."])

    expect(feedback.source_url).to eq(source_url)
  end
end
