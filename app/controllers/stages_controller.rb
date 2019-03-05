class StagesController < ApplicationController
    def index
        @stage = Stage.new
        @stages = Stage.all
    end

    def show
        @stage = Stage.find_by(id: params[:id])
    end
end
