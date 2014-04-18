require "spec_helper"

describe AssociationExtras do

	with_model :BlogPost do
    table do |t|
      t.string :title
      t.timestamps
    end

    model do
      has_many :comments
      validates_presence_of :title
      extend AssociationExtras
      association_extras :comments
    end
  end

  with_model :Comment do
    table do |t|
    	t.integer :blog_post_id
      t.string :text
      t.timestamps
    end

    model do
      belongs_to :blog_post
    end
  end

  it "can be accessed as a constant" do
    expect(BlogPost).to be
  end

  describe "injected methods" do

  	subject { BlogPost.new }
  	it { should respond_to :build_comments }
  	it { should respond_to :save_comments }
  	it {should respond_to :update_comments }

  	let(:comments) {{"1" => {text: "Comment 1"}, "2" => {text: "Comment 2"}}}
  	let(:comments_update) {{"3" => {text: "Comment 3"}, "4" => {text: "Comment 4"}, "5" => {text: "Comment 5"}}}

  	subject { BlogPost.create(title: "A blog post")}

  	context "build" do

  		before(:each) do
  			subject.build_comments(comments)
  		end

  		it { expect(subject.comments).to have(comments.length).items }
  		it { expect(subject.comments.all? {|o| o.new_record?}).to be_true }

  		context "save" do

  			before(:each) do
  				subject.save_comments
  			end

  			it { expect(subject.comments).to have(comments.length).items }
  			it { expect(subject.comments.all? {|o| o.new_record?}).to be_false }

  			context "update" do

  				before(:each) do
  					subject.update_comments(comments_update)
  					subject.save_comments
  				end

  				it { expect(subject.comments).to have(comments_update.length).items}
  				it { expect(subject.comments.find_by(text: "Comment 1")).to be_nil}
  				it { expect(subject.comments.find_by(text: "Comment 3")).to be_instance_of(Comment)}
  			end
  		end
  	end

  end



end