class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @book_comment = BookComment.new
  end

  def index
    tag_name = params[:tag_name]
    sort_type = params[:sort_type]

    if tag_name.present?
      @books = Book.where("category LIKE ?", "%#{tag_name}%")
    elsif sort_type.present?
      if sort_type == 'new'
        @books = Book.all.order(created_at: 'desc')
      else
        @books = Book.all.order(rate: 'desc')
      end
    else
      @books = Book.all
    end

    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :tag_name, :rate)
  end

  def ensure_correct_user
    @user = Book.find(params[:id]).user
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
