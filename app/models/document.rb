class Document < ActiveRecord::Base

  belongs_to :user

  has_many :attachments
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :comments

  validates_associated :attachments
  validates_associated :comments

  validates_presence_of :title, :description
  validates_length_of :title, maximum: 225, minimum: 6
  validates_length_of :description, maximum: 2000, minimum: 10
  validate :has_any_attachments

  resourcify

  scope :in_progress, -> { where(state:['in rework', 'in creation'])}
  scope :published, -> { where(state: 'published') }
  scope :pending, -> {where(state: ['pending review','pending publication'])}

##### ----- StateMachine ----- #####

  state_machine initial: :in_creation do

    before_transition on: :send_for_rework, do: :add_comment
    state :in_creation, value: 'in creation'
    state :in_rework, value: 'in rework'
    state :pending_review, value: 'pending review'
    state :pending_publication, value: 'pending publication'
    state :published, value: 'published'

    event :send_for_review do
      transition [:in_creation, :in_rework] => :pending_review
    end

    event :send_for_rework do
      transition pending_review: :in_rework
    end

    event :send_for_publication do
      transition pending_review: :pending_publication
    end

    event :publish do
      transition pending_publication: :published
    end
  end


  def add_comment(transition)
    update(transition.args.first)
  end


##### ----- End of StateMachine ----- #####


  def self.counted_by_state
    @result = {}
    @states = self.state_machine.states.map &:name
    @states.each do |state|
      @result[state.to_sym] = Document.with_state(state.to_sym).count
    end
    @result
  end

  def has_any_attachments
    self.attachments.any? ? true : errors.add(:base, "should have any attachments")
  end




end
