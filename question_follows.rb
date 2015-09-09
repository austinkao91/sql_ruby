

class QuestionFollows

  def self.most_followed_questions(n)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, n: n)
      SELECT
        questions.title, COUNT(question_follows.users_id) followers
      FROM
        question_follows
      JOIN
        questions ON question_follows.questions_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_follows.users_id) DESC
      LIMIT
        :n
    SQL

    data
  end
  def self.followers_for_question_id(id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, id: id)
        SELECT
          *
        FROM
          users
        JOIN
          question_follows on question_follows.users_id = users.id
        WHERE
          question_follows.questions_id = :id
      SQL

      followers = []
      data.each do |hash|
        followers << Users.new(hash)
      end

      followers
  end

  def self.followed_questions_for_user_id(users_id)
    db = QuestionsDatabase.instance
    data = db.execute(<<-SQL, users_id: users_id)
        SELECT
          *
        FROM
          questions
        JOIN
          question_follows on question_follows.questions_id = questions.id
        WHERE
            question_follows.users_id = :users_id
      SQL
      data.map {|hash| Questions.new(hash)}
    end
  attr_reader :questions_id, :users_id

  def initialize(attributes)
    @users_id = attributes['users_id']
    @questions_id = attributes['questions_id']
  end

end
# data = QuestionFollows.followed_questions_for_user_id(2)
# # data.each { |user| p user.inspect }
# p data
