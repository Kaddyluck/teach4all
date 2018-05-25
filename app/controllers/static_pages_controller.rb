class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :main

  def main
  end
end
