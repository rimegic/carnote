# app/controllers/concerns/pagination_concern.rb
module PaginationConcern
  extend ActiveSupport::Concern

  private

  def paginate_collection(collection, per_page: 12)
    page = params[:page]&.to_i || 1
    page = 1 if page < 1

    offset = (page - 1) * per_page
    total_count = collection.count
    total_pages = (total_count.to_f / per_page).ceil

    paginated_collection = collection.limit(per_page).offset(offset)

    {
      collection: paginated_collection,
      current_page: page,
      total_pages: total_pages,
      total_count: total_count,
      per_page: per_page,
      has_next: page < total_pages,
      has_prev: page > 1
    }
  end
end
