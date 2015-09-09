
class Replies

    def self.find_by_id(id)
      db = QuestionsDatabase.instance
      data = db.execute(<<-SQL, id: id).first
          SELECT
            *
          FROM
            replies
          WHERE
            id = :id
        SQL

        if data
          Replies.new(data)
        else
          raise "Reply not found!"
        end
    end

   def self.find_by_user_id(users_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, users_id: users_id)
        SELECT
          *
        FROM
          replies
        WHERE
          replies.users_id = :users_id
      SQL
      data.map {|hash| Replies.new(hash)}
    end

  def self.find_by_question_id(questions_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, questions_id: questions_id)
        SELECT
          *
        FROM
          replies
        WHERE
          replies.questions_id = :questions_id
      SQL
      data.map {|hash| Replies.new(hash)}
  end

  attr_reader :questions_id, :users_id, :parent_id, :body, :id

  def initialize(attributes)
    @id = attributes['id']
    @users_id = attributes['users_id']
    @questions_id = attributes['questions_id']
    @parent_id = attributes['parent_id']
    @body = attributes['body']
  end

  def author
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, users_id: @users_id).first
      SELECT
        *
      FROM
        users
      WHERE
        users.id = :users_id
    SQL
    if data
      Users.new(data)
    else
      raise "No author found for reply"
    end
  end

  def parent_reply
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, parent_id: parent_id).first
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = :parent_id
    SQL
    if data
      Replies.new(data)
    else
      raise "No parent reply found!"
    end
  end

  def question
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, questions_id: questions_id).first
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = :questions_id
    SQL
    if data
      Questions.new(data)
    else
      raise "No question found!"
    end
  end

  def child_replies
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id: @id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_id = :id
    SQL
    if data
      data.map{|hash| Replies.new(hash) }
    else
      raise "No replies found!"
    end
  end

end

# a = Replies.find_by_user_id(2)
# p a[0].child_replies
