class ChainController < ApplicationController
  def index
    @error = false
    @chain = false
    if ! params.has_key?(:token)
      @error = 'tokenを入力してください'
    end
    if ! params.has_key?(:code)
      @error = 'codeを入力してください'
    end
    if ! @error
      @chain = Chain.find_by(token: params[:token], code: params[:code])
      if ! @chain
        @error = 'データが見つかりませんでした'
      end
    end
  end

  def register
    @error = false
    if ! params.has_key?(:token)
      @error = 'tokenを入力してください'
    end
    if ! params.has_key?(:code)
      @error = 'codeを入力してください'
    end
    if ! @error
      @chain = Chain.new(token: params[:token], code: params[:code])
      if ! @chain.save
        @error = '登録に失敗しました'
      end
    end
  end

end
