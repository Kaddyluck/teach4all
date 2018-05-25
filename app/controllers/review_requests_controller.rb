class ReviewRequestsController < ApplicationController
  def index
    @review_requests = current_user.review_requests.includes(user_answer: :question)
  end

  def destroy
    @review_request = ReviewRequest.find(params[:id])
    if params[:correct] == 'true'
      @review_request.user_answer.update(status: :correct)
    else
      @review_request.user_answer.update(status: :uncorrect)
    end
    @review_request.user_answer.passing_course.set_result
    head :ok if @review_request.destroy
  end
end