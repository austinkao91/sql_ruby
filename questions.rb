
class Questions

  def save
    unless @id
      db = QuestionsDatabase.instance
      data = db.execute(<<-SQL, title: @title, body: @body, users_id: users_id)
      INSERT INTO
        questions (title, body, users_id)
      VALUES
        (:title, :body, :users_id)
      SQL
    else
      db = QuestionsDatabase.instance
      data = db.execute(<<-SQL, id: @id, title: @title, body: @body, users_id: users_id)
      UPDATE
        questions
      SET
        title = :title , body = :body, users_id = :users_id
      WHERE
        id = :id
      SQL
    end
  end

  def self.most_liked(n)
      QuestionLike.most_liked_questions(n)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def replies
    Replies.find_by_question_id(@id)
  end

  def author
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id: @users_id).first
      SELECT
        *
      FROM
        users
      WHERE
        users.id = :id
    SQL
    if data
      Users.new(data)
    else
      raise "No author found!"
    end
  end

  def self.find_by_id(id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id: id).first
        SELECT
          *
        FROM
          questions
        WHERE
          id = :id
      SQL

      if data
        Questions.new(data)
      else
        raise "Question not found!"
      end
  end

  def self.find_by_author_id(author_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, users_id: author_id)
        SELECT
          *
        FROM
          questions
        WHERE
          users_id = :users_id
      SQL

      if data
        data.map {|hash| Questions.new(hash) }
      else
        raise "Question not found!"
      end
    end
  attr_accessor :title, :body, :users_id, :id

  def initialize(attributes)
    @id = attributes['id']
    @title = attributes["title"]
    @body = attributes["body"]
    @users_id = attributes["users_id"]
  end


  def followers
    QuestionFollows.followers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

end
