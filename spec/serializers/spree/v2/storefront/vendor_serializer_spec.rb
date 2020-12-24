require 'spec_helper'

describe Spree::V2::Storefront::VendorSerializer do
  let(:vendor) { create(:vendor, name: 'Test', about_us: 'Hello World', contact_us: "Contact Us", slug: "slug") }

  subject { described_class.new(vendor) }

  it { expect(subject.serializable_hash).to be_kind_of(Hash) }
  it do
    expect(subject.serializable_hash).to eq(
      {
        data: {
          id: vendor.id.to_s,
          relationships: {
            image: {
              data: nil,
              products: {
                data: []
              }
            },
            type: vendor
          },
          attributes: {
            name: 'Test',
            contact_us: "Contact Us",
            about_us: 'Hello World',
            slug: "slug"
          }
        }
      }
    )
  end
end
