class QuestionsController < ApplicationController
  def ask
  end

  def answer
    @answer =
      if params[:question].end_with?('?')
        'Silly question, get dressed and go to work!'
      elsif params[:question].downcase == 'i am going to work'
        'Great!'
      else
        "I don't care, get dressed and go to work!"
      end
  end

  def home
  end
end
