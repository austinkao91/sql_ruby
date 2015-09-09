
class Users

  def save
    unless @id
      db = QuestionsDatabase.instance
      data = db.execute(<<-SQL, fname: @fname, lname: @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (:fname, :lname)
      SQL
    else
      db = QuestionsDatabase.instance
      data = db.execute(<<-SQL, id: @id, fname: @fname, lname: @lname)
      UPDATE
        users
      SET
        fname = :fname , lname = :lname
      WHERE
        id = :id
      SQL
    end
  end


  def average_karma
    # questions = authored_questions
    # sum = questions.inject(0) { |accum, q| accum + q.num_likes }
    # sum.to_f/questions.length
      # COUNT(question_likes.users_id) / COUNT(users.id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id: @id).first
    SELECT
      CAST( (COUNT(question_likes.users_id)/ COUNT(DISTINCT(questions.id))) AS FLOAT)
    FROM
      question_likes
    JOIN
      questions ON questions.id = question_likes.questions_id
    JOIN
      users ON users.id = questions.users_id
    GROUP BY
      users.id
    HAVING
      users.id = :id
    SQL
    data.values.first
  end

  def self.find_by_id(id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id: id).first
        SELECT
          *
        FROM
          users
        WHERE
          id = :id
      SQL

      if data
        Users.new(data)
      else
        raise "User not found!"
      end
  end

  def self.find_by_name(fname, lname)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, fname: fname, lname: lname).first
        SELECT
          *
        FROM
          users
        WHERE
          users.fname = :fname AND users.lname = :lname
      SQL

      if data
        Users.new(data)
      else
        raise "User not found!"
      end
    end

  attr_accessor :fname, :lname, :id

  def initialize(attributes)
    @id = attributes['id']
    @fname = attributes['fname']
    @lname = attributes['lname']
  end

  def authored_questions
    Questions.find_by_author_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end


end
