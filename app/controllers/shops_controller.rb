class ShopsController < EventsController
  before_action :authenticate_user!
  before_action :set_event
  before_action :correct_user
  before_action :set_shop, except: %w[create]
  
  def create
    @shop = @event.shops.new(shop_params)
    if @shop.save
      flash[:success] = '新しい候補「' + @shop.shop_name + '」を追加しました。'
      redirect_to event_url(@event)
    else
      flash[:danger] = 'お店の追加に失敗しました。エラー文を参照してください。'
      render action: :show
    end
  end
  
  def edit
  end

  def update
    name = @event.shops.find(params[:id]).shop_name
    if @shop.update_attributes(shop_params)
      flash[:success] = @shop.shop_name + 'を更新しました。'
      redirect_to @event
    else
      flash.now[:danger] = name + 'の更新に失敗しました。'
      render action: :show
    end
  end
  
  def destroy
  end
  
  
  private
  
    # beforeフィルター
  
    # 対象の参加メンバーを取得します。
    def set_shop
      if params[:id].present? && Shop.exists?(params[:id])
        @shop = @event.shops.find(params[:id])
      else
        flash[:danger] = 'id=' + params[:id] + 'のデータは存在しません。'
        redirect_to_home_page_url
      end
    end


    # Strong Parameters
      
    # shop#new
    def shop_params
      params.require(:shop).permit(:shop_name,
                                   :shop_url,
                                  :shop_station,
                                  :shop_address,
                                  :course,
                                  :price,
                                  :decided,
                                  :remark)
    end
end
