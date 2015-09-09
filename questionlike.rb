class QuestionLike

  def self.most_liked_questions(n)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, n: n)
      SELECT
        questions.*,
        COUNT(question_likes.users_id) likers
      FROM
        question_likes
      JOIN
        questions ON question_likes.questions_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_likes.users_id) DESC
      LIMIT
        :n
    SQL

    data.map{|hash| [Questions.new(hash),hash['likers']]}
  end

  def self.likers_for_question_id(id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id: id)
        SELECT
          *
        FROM
          users
        JOIN
          question_likes on question_likes.users_id= users.id
        WHERE
          question_likes.questions_id = :id
      SQL

      data.map do |hash|
        Users.new(hash)
      end

    end

  def self.num_likes_for_question_id(id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id: id)
      SELECT
        COUNT(question_likes.users_id) likers
      FROM
        question_likes
      JOIN
        questions ON question_likes.questions_id = questions.id
      GROUP BY
        questions.id
      HAVING
        question_likes.questions_id = :id
    SQL
    data.first['likers']

  end

  def self.liked_questions_for_user_id(id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON question_likes.questions_id = questions.id
      WHERE
        question_likes.users_id = :id
    SQL
    data.map{|hash| Questions.new(hash)}

  end
  attr_reader :questions_id, :users_id

  def initialize(attributes)
    @users_id = attributes['users_id']
    @questions_id = attributes['questions_id']
  end
end
