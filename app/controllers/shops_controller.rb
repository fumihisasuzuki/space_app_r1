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
    @shop.destroy
    flash[:success] = 'このイベントから「' + @shop.shop_name + '」を削除しました。'
    redirect_to event_url(@event)
  end
  
  def update_decision
    if @decided_shop.blank?
      if @shop.update_attribute(:decided, true) && @event.update_attribute(:event_status, "shop_decided")
        flash[:success] = @event.event_name + 'のお店を' + @shop.shop_name + 'に決定しました！'
      else
        flash[:danger] = 'なぜかお店の決定に失敗しました。管理者にお問い合わせください。'
      end
    else
      if @decided_shop.update_attribute(:decided, false) && @event.update_attribute(:event_status, "schedule_decided")
        flash[:success] = @event.event_name + 'のお店を再考することにしました。'
      else
        flash[:danger] = 'なぜかお店のリセットに失敗しました。管理者にお問い合わせください。'
      end
    end
    redirect_to @event
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
