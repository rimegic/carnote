class EstimatesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:start, :calculate, :quote_popup]
  def start
    @brand = params[:brand]
    @model = params[:model]
    @selected_car = find_car_data(@brand, @model) if @brand && @model
  end

  def calculate
    @brand = params[:brand]
    @model = params[:model]
    @price = params[:price].to_i
    @down_payment = params[:down_payment].to_i
    @loan_period = params[:loan_period].to_i

    @loan_amount = @price - @down_payment
    @estimates = calculate_loan_estimates(@loan_amount, @loan_period)

    render json: {
      estimates: @estimates,
      car_info: {
        brand: @brand,
        model: @model,
        price: @price,
        down_payment: @down_payment,
        loan_period: @loan_period
      }
    }
  end

  def quote_popup
    @brand = params[:brand]
    @model = params[:model]
    @price = params[:price]
    @estimate_type = params[:estimate_type]
    @monthly_payment = params[:monthly_payment]

    render layout: false
  end

  private

  def find_car_data(brand, model)
    car_data = {
      "현대" => {
        "아반떼" => { price: 20900000, image: "/generated_images/car_1.jpg" },
        "쏘나타" => { price: 28990000, image: "/generated_images/car_2.jpg" },
        "그랜저" => { price: 35200000, image: "/generated_images/car_3.jpg" },
        "아이오닉5" => { price: 52000000, image: "/generated_images/car_1.jpg" },
        "아이오닉6" => { price: 52900000, image: "/generated_images/car_2.jpg" },
        "투싼" => { price: 27550000, image: "/generated_images/car_3.jpg" },
        "싼타페" => { price: 35150000, image: "/generated_images/car_4.jpg" },
        "팰리세이드" => { price: 38380000, image: "/generated_images/car_5.jpg" },
        "캐스퍼" => { price: 13850000, image: "/generated_images/car_6.jpg" },
        "베뉴" => { price: 19690000, image: "/generated_images/car_1.jpg" }
      },
      "기아" => {
        "K3" => { price: 19550000, image: "/generated_images/car_4.jpg" },
        "K5" => { price: 27600000, image: "/generated_images/car_5.jpg" },
        "K8" => { price: 33050000, image: "/generated_images/car_6.jpg" },
        "K9" => { price: 46300000, image: "/generated_images/car_1.jpg" },
        "EV6" => { price: 48800000, image: "/generated_images/car_2.jpg" },
        "EV9" => { price: 73000000, image: "/generated_images/car_3.jpg" },
        "셀토스" => { price: 22680000, image: "/generated_images/car_4.jpg" },
        "스포티지" => { price: 27550000, image: "/generated_images/car_5.jpg" },
        "쏘렌토" => { price: 31930000, image: "/generated_images/car_6.jpg" },
        "모하비" => { price: 41730000, image: "/generated_images/car_1.jpg" },
        "레이" => { price: 14350000, image: "/generated_images/car_2.jpg" },
        "모닝" => { price: 12850000, image: "/generated_images/car_3.jpg" }
      },
      "제네시스" => {
        "G70" => { price: 45000000, image: "/generated_images/car_4.jpg" },
        "G80" => { price: 54050000, image: "/generated_images/car_5.jpg" },
        "G90" => { price: 87000000, image: "/generated_images/car_6.jpg" },
        "GV70" => { price: 50300000, image: "/generated_images/car_1.jpg" },
        "GV80" => { price: 69300000, image: "/generated_images/car_2.jpg" },
        "GV60" => { price: 59900000, image: "/generated_images/car_3.jpg" },
        "전동화 G80" => { price: 77550000, image: "/generated_images/car_4.jpg" },
        "전동화 GV70" => { price: 65800000, image: "/generated_images/car_5.jpg" }
      },
      "BMW" => {
        "1시리즈" => { price: 42000000, image: "/generated_images/car_6.jpg" },
        "2시리즈" => { price: 48900000, image: "/generated_images/car_1.jpg" },
        "3시리즈" => { price: 55000000, image: "/generated_images/car_2.jpg" },
        "4시리즈" => { price: 62000000, image: "/generated_images/car_3.jpg" },
        "5시리즈" => { price: 74000000, image: "/generated_images/car_4.jpg" },
        "7시리즈" => { price: 139000000, image: "/generated_images/car_5.jpg" },
        "X1" => { price: 47500000, image: "/generated_images/car_6.jpg" },
        "X3" => { price: 62000000, image: "/generated_images/car_1.jpg" },
        "X5" => { price: 89000000, image: "/generated_images/car_2.jpg" },
        "X7" => { price: 124000000, image: "/generated_images/car_3.jpg" },
        "iX3" => { price: 77000000, image: "/generated_images/car_4.jpg" },
        "i4" => { price: 69990000, image: "/generated_images/car_5.jpg" }
      },
      "벤츠" => {
        "A클래스" => { price: 42000000, image: "/generated_images/car_6.jpg" },
        "C클래스" => { price: 55000000, image: "/generated_images/car_1.jpg" },
        "E클래스" => { price: 72000000, image: "/generated_images/car_2.jpg" },
        "S클래스" => { price: 135000000, image: "/generated_images/car_3.jpg" },
        "GLA" => { price: 47500000, image: "/generated_images/car_4.jpg" },
        "GLB" => { price: 52000000, image: "/generated_images/car_5.jpg" },
        "GLC" => { price: 64000000, image: "/generated_images/car_6.jpg" },
        "GLE" => { price: 89000000, image: "/generated_images/car_1.jpg" },
        "GLS" => { price: 128000000, image: "/generated_images/car_2.jpg" },
        "EQA" => { price: 59990000, image: "/generated_images/car_3.jpg" },
        "EQB" => { price: 64990000, image: "/generated_images/car_4.jpg" },
        "EQC" => { price: 89990000, image: "/generated_images/car_5.jpg" }
      },
      "아우디" => {
        "A3" => { price: 42000000, image: "/generated_images/car_6.jpg" },
        "A4" => { price: 55000000, image: "/generated_images/car_1.jpg" },
        "A6" => { price: 72000000, image: "/generated_images/car_2.jpg" },
        "A8" => { price: 129000000, image: "/generated_images/car_3.jpg" },
        "Q2" => { price: 41000000, image: "/generated_images/car_4.jpg" },
        "Q3" => { price: 48900000, image: "/generated_images/car_5.jpg" },
        "Q5" => { price: 64000000, image: "/generated_images/car_6.jpg" },
        "Q7" => { price: 92000000, image: "/generated_images/car_1.jpg" },
        "Q8" => { price: 105000000, image: "/generated_images/car_2.jpg" },
        "e-tron" => { price: 99990000, image: "/generated_images/car_3.jpg" },
        "e-tron GT" => { price: 139990000, image: "/generated_images/car_4.jpg" }
      },
      "볼보" => {
        "XC40" => { price: 45900000, image: "/generated_images/car_5.jpg" },
        "XC60" => { price: 62000000, image: "/generated_images/car_6.jpg" },
        "XC90" => { price: 82000000, image: "/generated_images/car_1.jpg" },
        "S60" => { price: 49900000, image: "/generated_images/car_2.jpg" },
        "S90" => { price: 65000000, image: "/generated_images/car_3.jpg" },
        "XC40 리차지" => { price: 59990000, image: "/generated_images/car_4.jpg" },
        "XC60 리차지" => { price: 74990000, image: "/generated_images/car_5.jpg" },
        "XC90 리차지" => { price: 94990000, image: "/generated_images/car_6.jpg" }
      },
      "렉서스" => {
        "IS" => { price: 47000000, image: "/generated_images/car_1.jpg" },
        "ES" => { price: 55000000, image: "/generated_images/car_2.jpg" },
        "LS" => { price: 119000000, image: "/generated_images/car_3.jpg" },
        "NX" => { price: 52000000, image: "/generated_images/car_4.jpg" },
        "RX" => { price: 72000000, image: "/generated_images/car_5.jpg" },
        "GX" => { price: 95000000, image: "/generated_images/car_6.jpg" },
        "LX" => { price: 135000000, image: "/generated_images/car_1.jpg" },
        "UX" => { price: 42000000, image: "/generated_images/car_2.jpg" },
        "LC" => { price: 129000000, image: "/generated_images/car_3.jpg" }
      }
    }

    car_data.dig(brand, model)
  end

  def calculate_loan_estimates(loan_amount, loan_period)
    [
      {
        bank: "카노트 제휴 은행",
        type: "일반 할부",
        interest_rate: 2.9,
        monthly_payment: calculate_monthly_payment(loan_amount, 2.9, loan_period),
        total_payment: calculate_total_payment(loan_amount, 2.9, loan_period),
        benefits: [ "최저금리 보장", "수수료 면제" ]
      },
      {
        bank: "국민은행",
        type: "신차 할부",
        interest_rate: 3.2,
        monthly_payment: calculate_monthly_payment(loan_amount, 3.2, loan_period),
        total_payment: calculate_total_payment(loan_amount, 3.2, loan_period),
        benefits: [ "KB국민카드 할인", "주거래 우대" ]
      },
      {
        bank: "신한은행",
        type: "오토론",
        interest_rate: 3.5,
        monthly_payment: calculate_monthly_payment(loan_amount, 3.5, loan_period),
        total_payment: calculate_total_payment(loan_amount, 3.5, loan_period),
        benefits: [ "신한카드 포인트", "보험료 할인" ]
      },
      {
        bank: "하나은행",
        type: "하나 오토론",
        interest_rate: 3.8,
        monthly_payment: calculate_monthly_payment(loan_amount, 3.8, loan_period),
        total_payment: calculate_total_payment(loan_amount, 3.8, loan_period),
        benefits: [ "하나머니 적립", "금리 우대" ]
      }
    ]
  end

  def calculate_monthly_payment(principal, annual_rate, months)
    monthly_rate = annual_rate / 100 / 12
    if monthly_rate == 0
      principal / months
    else
      (principal * monthly_rate * (1 + monthly_rate) ** months) / ((1 + monthly_rate) ** months - 1)
    end.round
  end

  def calculate_total_payment(principal, annual_rate, months)
    monthly_payment = calculate_monthly_payment(principal, annual_rate, months)
    monthly_payment * months
  end
end
