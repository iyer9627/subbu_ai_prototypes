import Foundation

/// A short verbatim line from a beloved book, with the author's age when it
/// was published. Used on milestone card backs: "when this author was the
/// age you'll be at this milestone, they published this."
public struct BookQuote: Equatable, Identifiable, Sendable {
    public let text: String
    public let book: String
    public let author: String
    public let publicationYear: Int
    public let authorBirthYear: Int

    public var authorAgeAtPublication: Int { publicationYear - authorBirthYear }
    public var id: String { "\(author)-\(publicationYear)-\(text.prefix(20))" }

    public init(text: String, book: String, author: String, publicationYear: Int, authorBirthYear: Int) {
        self.text = text
        self.book = book
        self.author = author
        self.publicationYear = publicationYear
        self.authorBirthYear = authorBirthYear
    }
}

/// Curated uplifting lines — mostly beloved fiction, all real, all
/// attributed with publication year and author age. Nothing is generated.
public enum QuoteBank {
    public static let all: [BookQuote] = [
        BookQuote(
            text: "Beware; for I am fearless, and therefore powerful.",
            book: "Frankenstein", author: "Mary Shelley",
            publicationYear: 1818, authorBirthYear: 1797
        ),
        BookQuote(
            text: "It is not down on any map; true places never are.",
            book: "Moby-Dick", author: "Herman Melville",
            publicationYear: 1851, authorBirthYear: 1819
        ),
        BookQuote(
            text: "There is nothing in the world so irresistibly contagious as laughter and good humour.",
            book: "A Christmas Carol", author: "Charles Dickens",
            publicationYear: 1843, authorBirthYear: 1812
        ),
        BookQuote(
            text: "Sometimes I've believed as many as six impossible things before breakfast.",
            book: "Through the Looking-Glass", author: "Lewis Carroll",
            publicationYear: 1871, authorBirthYear: 1832
        ),
        BookQuote(
            text: "I am not afraid of storms, for I am learning how to sail my ship.",
            book: "Little Women", author: "Louisa May Alcott",
            publicationYear: 1868, authorBirthYear: 1832
        ),
        BookQuote(
            text: "Isn't it nice to think that tomorrow is a new day with no mistakes in it yet?",
            book: "Anne of Green Gables", author: "L. M. Montgomery",
            publicationYear: 1908, authorBirthYear: 1874
        ),
        BookQuote(
            text: "There is nothing — absolutely nothing — half so much worth doing as simply messing about in boats.",
            book: "The Wind in the Willows", author: "Kenneth Grahame",
            publicationYear: 1908, authorBirthYear: 1859
        ),
        BookQuote(
            text: "To live will be an awfully big adventure.",
            book: "Peter and Wendy", author: "J. M. Barrie",
            publicationYear: 1911, authorBirthYear: 1860
        ),
        BookQuote(
            text: "If you look the right way, you can see that the whole world is a garden.",
            book: "The Secret Garden", author: "Frances Hodgson Burnett",
            publicationYear: 1911, authorBirthYear: 1849
        ),
        BookQuote(
            text: "There is nothing like looking, if you want to find something.",
            book: "The Hobbit", author: "J. R. R. Tolkien",
            publicationYear: 1937, authorBirthYear: 1892
        ),
        BookQuote(
            text: "It is only with the heart that one can see rightly; what is essential is invisible to the eye.",
            book: "The Little Prince", author: "Antoine de Saint-Exupéry",
            publicationYear: 1943, authorBirthYear: 1900
        ),
        BookQuote(
            text: "Some day you will be old enough to start reading fairy tales again.",
            book: "The Lion, the Witch and the Wardrobe", author: "C. S. Lewis",
            publicationYear: 1950, authorBirthYear: 1898
        ),
        BookQuote(
            text: "You have been my friend. That in itself is a tremendous thing.",
            book: "Charlotte's Web", author: "E. B. White",
            publicationYear: 1952, authorBirthYear: 1899
        ),
        BookQuote(
            text: "So many things are possible just as long as you don't know they're impossible.",
            book: "The Phantom Tollbooth", author: "Norton Juster",
            publicationYear: 1961, authorBirthYear: 1929
        ),
        BookQuote(
            text: "Believing takes practice.",
            book: "A Wrinkle in Time", author: "Madeleine L'Engle",
            publicationYear: 1962, authorBirthYear: 1918
        ),
        BookQuote(
            text: "Every real story is a neverending story.",
            book: "The Neverending Story", author: "Michael Ende",
            publicationYear: 1979, authorBirthYear: 1929
        ),
        BookQuote(
            text: "Those who don't believe in magic will never find it.",
            book: "The Minpins", author: "Roald Dahl",
            publicationYear: 1991, authorBirthYear: 1916
        ),
        BookQuote(
            text: "The moment you doubt whether you can fly, you cease for ever to be able to do it.",
            book: "Peter Pan in Kensington Gardens", author: "J. M. Barrie",
            publicationYear: 1906, authorBirthYear: 1860
        ),
        BookQuote(
            text: "There's no place like home.",
            book: "The Wonderful Wizard of Oz", author: "L. Frank Baum",
            publicationYear: 1900, authorBirthYear: 1856
        ),
        BookQuote(
            text: "Real courage is when you know you're licked before you begin, but you begin anyway.",
            book: "To Kill a Mockingbird", author: "Harper Lee",
            publicationYear: 1960, authorBirthYear: 1926
        ),
    ]

    /// The quotes whose authors were closest in age to `age` at publication,
    /// nearest first. Flip through the pool to change quotes without repeats.
    public static func pool(forAge age: Int, count: Int = 6) -> [BookQuote] {
        Array(
            all.sorted {
                abs($0.authorAgeAtPublication - age) < abs($1.authorAgeAtPublication - age)
            }
            .prefix(count)
        )
    }
}
