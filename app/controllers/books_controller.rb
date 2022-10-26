class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :correct_user, only: [ :edit, :update, :destroy ]

  require 'json'
  require 'net/http'
  require 'uri'
  
  # GET /books or /books.json
  
  def index
    @books = Book.all
    book_ids = Book.pluck(:id)
    @book = Book.find(book_ids.sample)
    @reviews = Review.where(book_id: @book.id)
    @stars = @book.reviews.average(:stars)


  end

  # GET /books/1 or /books/1.json
  def show
    @pagy, @reviews = pagy(Review.where(book_id: @book.id))
    # @average_rating = @reviews.stars.sum(0.0) / @reviews.count
  end

  # GET /books/new
  def new
   @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.build(book_params) if manually_adding?
    @book = book_from_scan(params[:isbn]) if searching_by_isbn?

    respond_to do |format|
      if @book == false
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      elsif @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def correct_user
    @book = current_user.books.find_by(id: params[ :id])
    redirect_to books_path, notice: "Not authorized to edit this book" if @book.nil?
  end

  def searching_by_isbn?
    params[:commit] == "Search"
  end

  def manually_adding?
    params[:commit] == "Create Book"
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:id).permit(:title, :author, :cover_text, :short_description, :cost, :collection, :case, :shelf, :ISBN)
  end

  def book_from_scan(isbn)

    isbn_link = "https://openlibrary.org/api/books?bibkeys=ISBN:"+isbn+"&jscmd=data&format=json"
    uri = URI.parse(isbn_link)
    response = Net::HTTP.get_response(uri)
    parsed_json = JSON.parse(response.body)
    info = parsed_json["ISBN:"+isbn]

    if info.nil?
      @book = Book.new(title: info['title'], authors: authors, publisher: publishers,
        edition: info['publish_date'], pages: info['number_of_pages'], isbn: isbn,
        cover_link: info['cover']['medium'])
    else
      authors = join_field(info['authors'])
      publishers = join_field(info['publishers'])
      @book = Book.new
      @book = Book.update(
        title: info['title'],
        authors: authors,
        publisher: publishers,
        edition: info['publish_date'],
        pages: info['number_of_pages'],
        isbn: isbn,
        cover_link: info['cover']['medium'],
        user_id: current_user)
    end
  end

  def join_field(field)
    field.map do |a|
      "#{a['name']}"
    end.join
  end
end
