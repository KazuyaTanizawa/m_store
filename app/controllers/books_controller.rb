class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  def m_new
    @books =[]
    2.times{@books << Book.new
    }
    @nextaction = :m_create
  end

  # GET /books/1/edit
  def edit
  end
  def m_edit
    books = Book.all
    @books = []
    books.each{|book|@books << book}

    @nextaction = :m_update
  end

  # POST /books
  # POST /books.json
  def create

    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render action: 'show', status: :created, location: @book }
      else
        format.html { render action: 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  def m_create

    @books = []

    @isError =false
    ActiveRecord::Base.transaction do
      @nextaction = :m_create
      params[:book].each{|book|
        if Book.new(book).valid? == false then
          @isError = true
        end
        b =  Book.new(book)
        @books << b
        b.save
      }
      if @isError == true then
         raise ActiveRecord::Rollback
      end
    end
    #params[:book].each{|book| book.permit(:title, :price)}
    #@books = Book.new(params[:book])
    #raise

    respond_to do |format|
      if @isError == false
        format.html { redirect_to :action => :index, notice: 'Book was successfully created.' }
        #format.json { render action: 'show', status: :created, location: @books }
      else

        @books.each{|book| book.updated_at = nil;book.created_at = nil;book.id = nil}
        @books.each{|book| p book}
        format.html { render action: 'm_new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  def m_update
    raise
    @books = Book.update(params[:book].keys,params[:book].values)

    @isError = false
    @books.each{|book| @isError = true if book.errors.any?}
    @nextaction = :m_update
    respond_to do |format|
      if @isError == false
        format.html { redirect_to :action => :index, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'm_edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
  def m_destroy
    Book.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to :action => :m_edit}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book

      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
    params.require(:book).permit(:title, :price)
    end
  def m_book_params
    params[:book].each{|book|
    #params.require(:book).permit(:title, :price)
    }
  end
end
