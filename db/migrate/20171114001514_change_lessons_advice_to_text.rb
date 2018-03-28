class ChangeLessonsAdviceToText < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :relevant_articles, :text

    reversible do |dir|
      dir.up do
        Lesson.find_each do |lesson|
          next unless lesson.advice.present?

          links = lesson.advice.map do |article|
            %(<li><a href="https://sec.eff.org/articles/#{article.slug}">#{article.name}</a></li>)
          end

          lesson.update(relevant_articles: "<ul>#{links.join}</ul>")
        end
      end
    end
  end
end
