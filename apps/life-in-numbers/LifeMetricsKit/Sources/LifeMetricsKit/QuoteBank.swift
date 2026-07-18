import Foundation

/// A short verbatim line from a beloved book, with the author's age when it
/// was published. Used on milestone card backs: "when this author was the
/// age you'll be at this milestone, they published this."
public struct BookQuote: Equatable, Identifiable, Sendable {
    public let text: String
    /// The work: a book, film, show, song, or speech.
    public let book: String
    /// The person whose age anchors the card: author, director, songwriter…
    public let author: String
    public let publicationYear: Int
    public let authorBirthYear: Int
    public let interest: Interest

    public var authorAgeAtPublication: Int { publicationYear - authorBirthYear }
    public var id: String { "\(author)-\(publicationYear)-\(text.prefix(20))" }

    public init(text: String, book: String, author: String, publicationYear: Int, authorBirthYear: Int, interest: Interest = .books) {
        self.text = text
        self.book = book
        self.author = author
        self.publicationYear = publicationYear
        self.authorBirthYear = authorBirthYear
        self.interest = interest
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

        // Movies — anchored to the director/writer's age at release.
        BookQuote(text: "Do or do not. There is no try.",
                  book: "The Empire Strikes Back", author: "George Lucas",
                  publicationYear: 1980, authorBirthYear: 1944, interest: .movies),
        BookQuote(text: "Life moves pretty fast. If you don't stop and look around once in a while, you could miss it.",
                  book: "Ferris Bueller's Day Off", author: "John Hughes",
                  publicationYear: 1986, authorBirthYear: 1950, interest: .movies),
        BookQuote(text: "To infinity and beyond!",
                  book: "Toy Story", author: "John Lasseter",
                  publicationYear: 1995, authorBirthYear: 1957, interest: .movies),
        BookQuote(text: "Just keep swimming.",
                  book: "Finding Nemo", author: "Andrew Stanton",
                  publicationYear: 2003, authorBirthYear: 1965, interest: .movies),
        BookQuote(text: "Why do we fall? So we can learn to pick ourselves up.",
                  book: "Batman Begins", author: "Christopher Nolan",
                  publicationYear: 2005, authorBirthYear: 1970, interest: .movies),
        BookQuote(text: "Ohana means family. Family means nobody gets left behind or forgotten.",
                  book: "Lilo & Stitch", author: "Chris Sanders",
                  publicationYear: 2002, authorBirthYear: 1962, interest: .movies),

        // TV
        BookQuote(text: "Live long and prosper.",
                  book: "Star Trek", author: "Gene Roddenberry",
                  publicationYear: 1967, authorBirthYear: 1921, interest: .tv),
        BookQuote(text: "We're all stories, in the end. Just make it a good one, eh?",
                  book: "Doctor Who", author: "Steven Moffat",
                  publicationYear: 2010, authorBirthYear: 1961, interest: .tv),
        BookQuote(text: "I wish there was a way to know you're in the good old days before you've actually left them.",
                  book: "The Office", author: "Greg Daniels",
                  publicationYear: 2013, authorBirthYear: 1963, interest: .tv),
        BookQuote(text: "Be curious, not judgmental.",
                  book: "Ted Lasso", author: "Jason Sudeikis",
                  publicationYear: 2020, authorBirthYear: 1975, interest: .tv),

        // Music — songwriter's age when the song came out.
        BookQuote(text: "Here comes the sun, and I say it's all right.",
                  book: "Abbey Road", author: "George Harrison",
                  publicationYear: 1969, authorBirthYear: 1943, interest: .music),
        BookQuote(text: "Imagine all the people living life in peace.",
                  book: "Imagine", author: "John Lennon",
                  publicationYear: 1971, authorBirthYear: 1940, interest: .music),
        BookQuote(text: "Every little thing is gonna be all right.",
                  book: "Three Little Birds", author: "Bob Marley",
                  publicationYear: 1977, authorBirthYear: 1945, interest: .music),
        BookQuote(text: "Don't stop believin'. Hold on to that feelin'.",
                  book: "Don't Stop Believin'", author: "Steve Perry",
                  publicationYear: 1981, authorBirthYear: 1949, interest: .music),
        BookQuote(text: "I see trees of green, red roses too — and I think to myself, what a wonderful world.",
                  book: "What a Wonderful World", author: "Louis Armstrong",
                  publicationYear: 1967, authorBirthYear: 1901, interest: .music),

        // Sports — the athlete's age when they said or published it.
        BookQuote(text: "You miss one hundred percent of the shots you don't take.",
                  book: "an interview", author: "Wayne Gretzky",
                  publicationYear: 1983, authorBirthYear: 1961, interest: .sports),
        BookQuote(text: "I've failed over and over and over again in my life. And that is why I succeed.",
                  book: "Nike's Failure ad", author: "Michael Jordan",
                  publicationYear: 1997, authorBirthYear: 1963, interest: .sports),
        BookQuote(text: "Don't count the days; make the days count.",
                  book: "The Greatest: My Own Story", author: "Muhammad Ali",
                  publicationYear: 1975, authorBirthYear: 1942, interest: .sports),

        // Tech
        BookQuote(text: "The Analytical Engine weaves algebraical patterns just as the Jacquard loom weaves flowers and leaves.",
                  book: "Notes on the Analytical Engine", author: "Ada Lovelace",
                  publicationYear: 1843, authorBirthYear: 1815, interest: .tech),
        BookQuote(text: "The best way to predict the future is to invent it.",
                  book: "a PARC meeting", author: "Alan Kay",
                  publicationYear: 1971, authorBirthYear: 1940, interest: .tech),
        BookQuote(text: "A ship in port is safe, but that is not what ships are built for.",
                  book: "a Navy address", author: "Grace Hopper",
                  publicationYear: 1981, authorBirthYear: 1906, interest: .tech),
        BookQuote(text: "Stay hungry. Stay foolish.",
                  book: "the Stanford commencement address", author: "Steve Jobs",
                  publicationYear: 2005, authorBirthYear: 1955, interest: .tech),
        BookQuote(text: "This is for everyone.",
                  book: "the London Olympics opening ceremony", author: "Tim Berners-Lee",
                  publicationYear: 2012, authorBirthYear: 1955, interest: .tech),

        // Pop culture
        BookQuote(text: "With great power there must also come great responsibility.",
                  book: "Amazing Fantasy #15", author: "Stan Lee",
                  publicationYear: 1962, authorBirthYear: 1922, interest: .popCulture),
        BookQuote(text: "Life's like a movie: write your own ending. Keep believing, keep pretending.",
                  book: "The Muppet Movie", author: "Jim Henson",
                  publicationYear: 1979, authorBirthYear: 1936, interest: .popCulture),
    ]

    /// The quotes whose creators were closest in age to `age`, nearest
    /// first, preferring the user's chosen interest and padding with the
    /// book classics when that shelf runs short. Flip through the pool to
    /// change quotes without repeats.
    public static func pool(forAge age: Int, interest: Interest = .books, count: Int = 6) -> [BookQuote] {
        func nearest(_ quotes: [BookQuote]) -> [BookQuote] {
            quotes.sorted { abs($0.authorAgeAtPublication - age) < abs($1.authorAgeAtPublication - age) }
        }
        var pool = nearest(all.filter { $0.interest == interest })
        if pool.count < count {
            let padding = nearest(all.filter { $0.interest == .books && interest != .books })
            pool.append(contentsOf: padding)
        }
        return Array(pool.prefix(count))
    }
}
