const faker = require('faker')

const express = require('express')
const app = express()
const port = 3000

// SFSymbols to stand in as product images
productImages = ['headphones', 'gift', 'alarm', 'lightbulb', 'bandage', 'metronome', 'paperclip', 'book', 'pencil', 'flag']

function sample(array) {
  const index = Math.floor(array.length * Math.random())
  return array[index]
}

const logger = (req, res, next) => {
  console.log(`Request made to: ${req.url}`)
  next()
}
app.use(logger)

app.get('/home_content', (req, res) => {
  res.send({
    'sections': [
      {
        'kind': 'banner',
        'ab_test_set': 'a',
        'id': 0
      },
      {
        'kind': 'shortcut',
        'ab_test_set': 'a',
        'id': 1
      },
      {
        'kind': 'featured_product',
        'title': faker.lorem.words(),
        'subtitle': faker.lorem.sentence(),
        'id': 2
      },
      {
        'kind': 'article',
        'title': 'Articles',
        'id': 3
      },
      {
        'kind': 'featured_product',
        'title': faker.lorem.words(),
        'subtitle': faker.lorem.sentence(),
        'id': 4
      },
      {
        'kind': 'featured_product',
        'title': faker.lorem.words(),
        'subtitle': faker.lorem.sentence(),
        'id': 5
      },
      {
        'kind': 'featured_product',
        'title': faker.lorem.words(),
        'subtitle': faker.lorem.sentence(),
        'id': 4
      }
    ]
  })
})
app.get('/featured_products', (req, res) => {
  res.send({
    'products': [
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'name': faker.commerce.productName(),
        'price': faker.commerce.price()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'name': faker.commerce.productName(),
        'price': faker.commerce.price()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'name': faker.commerce.productName(),
        'price': faker.commerce.price()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'name': faker.commerce.productName(),
        'price': faker.commerce.price()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'name': faker.commerce.productName(),
        'price': faker.commerce.price()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'name': faker.commerce.productName(),
        'price': faker.commerce.price()
      }
    ]
  })
})
app.get('/shortcuts', (req, res) => {
  res.send({
    'shortcuts': [
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'title': 'Theme'
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'title': 'Stories'
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'title': 'Gift'
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'title': 'Ranking'
      }
    ]
  })
})
app.get('/articles', (req, res) => {
  res.send({
    'articles': [
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'title': faker.lorem.words(),
        'subtitle': faker.lorem.paragraph()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'title': faker.lorem.words(),
        'subtitle': faker.lorem.paragraph()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid(),
        'title': faker.lorem.words(),
        'subtitle': faker.lorem.paragraph()
      }
    ]
  })
})
app.get('/banners', (req, res) => {
  res.send({
    'banners': [
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid()
      },
      {
        'image_url': sample(productImages),
        'id': faker.random.uuid()
      }
    ]
  })
})

app.listen(port, () => console.log(`Listening at http://localhost:${port}`))
