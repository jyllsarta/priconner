class CharactersController < ApplicationController
    def index
        @character = Character.new
        @characters = Character.all
    end

    def show
        @character = Character.find_by(id: params[:id])
    end
end
