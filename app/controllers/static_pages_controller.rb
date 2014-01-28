class StaticPagesController < ApplicationController
  def home
  end
  def showcase
  	@locations = Location.all
  end
end
