# Chipp'd Spec

## Layout

The global layout for Chipp'd will feature a responsive design except where noted.  Global elements of the layout will include main navigation, a link to login, cart content indicator (only displayed if the cart is not empty), a mailing list signup, and a footer.

The main navigation will contain links to three sections: About Us, Ways To Use, and Retailers.

The mailing list signup will submit asynchronously using [this method](https://gist.github.com/1155479), same as what we implemented on the teaser site.

The footer navigation will contain links to information and legal pages as well as social network pages.  These links will include: Blog, Press, FAQ, Contact Us, Terms of Service, Privacy Policy, Twitter, and Facebook.

The layout will use a custom grid system along with UI components from Twitter's Bootstrap 2 library (buttons, alerts, forms, etc.)

## Homepage

The primary area of the homepage will contain a slideshow of featured products.  This slideshow will be CMT-controlled and use large images that will link through to the individual product pages.

Below the primary content will be three large clickable areas that link to the brand promo video, download page, and the ways to use page, respectively.

Below those three areas will be a list of use cases (CMT-controlled - title, abstract, image).

## Download

This page should contain links to all versions of the app (iOS, Android, and Blackberry).

## Ways To Use

* Static, fully designed page (not CMT-controlled)

## FAQ

The FAQs page will be your standard question/answer-style page with a list of jump links at the top of the page that link down to the section of the page where that question is answered.

## About Us

* CMT-controlled text-only page

## Retailers

* CMT-controlled text-only page

## Blog

* Tumblr skin matching the main site's design.

## Terms of Service

* CMT-controlled text-only page

## Privacy Policy

* CMT-controlled text-only page

## Contact

* Contact request form containing topic, email, and message fields
* Topic options TBD
* Negative captcha should be used to prevent spam submissions of the form
* Form should submit asynchronously
* Data captured should be available in the CMS for review and emailed to the admin email address

## Press

* CMT-controlled content (title, small image, large image, abstract, and body)
* List view containing title, small image, abstract, and link to full article (/press)
* Full article view (/press/abc123) containing title, large image, body and link back to list view

## Login

* Form: email address and password
* Link to forgot password form
* If successful, redirects to "My Chipps"

## Forgot Password

* Form: email address
* Sends email with password reset link to email address entered
* If successful, redirects to confirmation page

## Password Reset

* Form: password, password confirmation
* If successful, redirects to login page

## My Chipps

* Listing of all Chipps purchased in reverse chronological order
* Display name, image, purchase date, privacy type (private, public, semi-private), link to purchase more chipps that are mapped to the same page as each Chipp (modified checkout process with no gift options)
* Button to edit-in-place name (defaults to product name)
* Button to "Edit Chipp" page

## Edit Chipp

Display and editing ability for all attributes of a Chipp. By default all Chipps have their name set to the product they are and a privacy setting of "public".

* Display name, image, purchase date, privacy type (private, public, semi-private)
* Privacy explanation and management. 
** If the product is public, show how many people have access to the page.
** Allow changing from public to private and vice-versa
** If private, show a list of phone numbers who have accessed the page and allow adding a name and deleting/blocking that number. Deleting opens access to the chip, but doesn't prevent that same number from scanning the page again.  Blocking removes access to the page for that number permanently
* Page Builder UI ([see this](#s-page-builder))
* Auto-save functionality
* Semi-private products have a pre-set number of people who can access the page, therefore don't have the ability to move between public and private.  The number is set at checkout.  Customers can purchase additional products to add to this number.

**It will not be a responsive layout.**

## My Info

Allow the user to modify first name, last name, email, password, and mailing list opt-in.

## Product

* Products have a name, description, color, and multiple images (two sizes - thumb and large).
* Image gallery is JS-driven with no reloads. Cross-fade between images.
* Add to cart includes both color and quantity.
* Link to "[Ways to Use this Product](#s-ways-to-use)"
* List and link to other products available

## Cart

The cart should list product name, image, unit price, quantity, and subtotal. It should allow updating of quantity and removal of items. There should be the ability to apply a gift code to your cart and the totals should be updated accordingly.

Clicking Proceed to Checkout will launch the checkout process.

## Gift Codes

There will be two types of gift codes possible: dollar amount off and percentage off. Each gift code will have a unique, customizable code that identifies it when a customer uses it as well as either a dollar or percentage amount off for that code.

## Checkout

The first step of the checkout process will either authenticate an existing user or allow the user to create an account if they don't have one already.

The second step will collect shipping destination information.

The third step will allow the user to select a shipping option (with prices calculated) and set gift options (more on this below).

The fourth step allows the user to enter their billing information with an option to save their information for future use (data will be stored in Authorize.Net's CIM system).

The fifth step will collect the billing address.

The final step will be a review page containing the cart contents, all information entered in prior steps, links back to edit the information from prior steps, and a cost breakdown (subtotal, tax, shipping, grand total).

By default, the gift option is set to false.  In this case, all other gift option fields (recipient email, note, and URL option) are hidden.  If the gift option is set to true, those fields are displayed.

In the event that a user is already logged in when entering into the checkout process, an order is created using the information from their last order as a starting point.  This includes billing information only if they'd checked the option to save that info for future use.

Sales tax at a rate of X% should only be charged to customers with a billing address in New York state.

Once an order is placed, if the gift options dictate that the purchaser has control over the URL associated with the product, they're presented with a link to start managing that page.  If the URL and product are both being sent to the gift recipient, an appropriate message is displayed. In this scenario a card will be included in the box that has a redemption code (and a url to use: http://chippd.com/redeem) on it allowing the recipient to create an account and start managing the URL for the product they were gifted.  Regardless of gift options, a receipt should be emailed to the purchaser.

## Redeem

The Redeem page is used to associate a product gifted to you with your Chipp'd account.  The user will enter their redemption code and either log in (if they already have a Chipp'd account) or create a new account.  The product gifted to them will automatically be associated with their account once they've been authenticated via lookup with the redemption code.

## Page Builder

TBD

## Page Access API

TBD

## QR Code Management

Each Chipp has a unique URL, and therefore QRCode associated with it.  URL structure is TBD, and for now, we'll operate on the assumption that we'll use the Google Charts API for generation, assuming it meets the specs of the client.

* ![Example QR Code](http://chart.apis.google.com/chart?cht=qr&chs=200x200&chl=http://chippd.com/l/x6hWRD3kLpx&chld=H|0)
* [Google Charts API QRCode documentation](http://code.google.com/apis/chart/infographics/docs/qr_codes.html)

## Analytics

Basic site analytics will be collected via Google Analytics, as well as important conversion information (through the use of conversion funnels) e.g. basic checkout, redeem flow.  Conversion tracking should include financial information.

## Order Management

TBD

## Customer Management

TBD

## Product Management

TBD

## Contact Request Management

TBD
