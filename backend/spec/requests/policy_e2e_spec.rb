require "rails_helper"

RSpec.describe "Policy E2E", type: :request do
  it "enforces run visibility correctly across users and follows" do
    # ---- users
    u1 = User.create!(email: "u1@test.dev", password: "password")
    u2 = User.create!(email: "u2@test.dev", password: "password")
    u3 = User.create!(email: "u3@test.dev", password: "password")
    u4 = User.create!(email: "u4@test.dev", password: "password") # pending follower of u1
    u5 = User.create!(email: "u5@test.dev", password: "password") # rejected follower of u1
    u6 = User.create!(email: "u6@test.dev", password: "password") # no follow relation to u1

    # ---- runs
    r1_only   = u1.runs.create!(started_at: 1.hour.ago, ended_at: Time.now, privacy: "only_me")
    r1_open   = u1.runs.create!(started_at: 1.hour.ago, ended_at: Time.now, privacy: "open")
    r1_friend = u1.runs.create!(started_at: 1.hour.ago, ended_at: Time.now, privacy: "friends")

    r2_only   = u2.runs.create!(started_at: 1.hour.ago, ended_at: Time.now, privacy: "only_me")
    r2_open   = u2.runs.create!(started_at: 1.hour.ago, ended_at: Time.now, privacy: "open")
    r2_friend = u2.runs.create!(started_at: 1.hour.ago, ended_at: Time.now, privacy: "friends")

    r3_only   = u3.runs.create!(started_at: 1.hour.ago, ended_at: Time.now, privacy: "only_me")
    r3_open   = u3.runs.create!(started_at: 1.hour.ago, ended_at: Time.now, privacy: "open")
    r3_friend = u3.runs.create!(started_at: 1.hour.ago, ended_at: Time.now, privacy: "friends")

    # ---- follows (accepted)
    Follow.create!(follower: u1, followee: u2, status: "accepted")
    Follow.create!(follower: u1, followee: u3, status: "accepted")
    Follow.create!(follower: u2, followee: u3, status: "accepted")

    # ---- pending: u4 requested to follow u1, not yet accepted
    Follow.create!(follower: u4, followee: u1, status: "pending")

    # ---- rejected: u5's follow request to u1 was rejected
    Follow.create!(follower: u5, followee: u1, status: "rejected")

    # ---- u1 (accepted follower of u2, u3) can see their friends runs
    get "/runs/#{r2_friend.id}", headers: auth_header_for(u1)
    expect(response).to have_http_status(:ok)

    get "/runs/#{r3_friend.id}", headers: auth_header_for(u1)
    expect(response).to have_http_status(:ok)

    # ---- u1 cannot see u2's only_me
    get "/runs/#{r2_only.id}", headers: auth_header_for(u1)
    expect(response).to have_http_status(:forbidden)

    # ---- u2 does not follow u1 → cannot see u1's friends run
    get "/runs/#{r1_friend.id}", headers: auth_header_for(u2)
    expect(response).to have_http_status(:forbidden)

    # ---- u2 (accepted follower of u3) can see u3's friends run
    get "/runs/#{r3_friend.id}", headers: auth_header_for(u2)
    expect(response).to have_http_status(:ok)

    # ---- open runs visible to any authenticated user
    get "/runs/#{r3_open.id}", headers: auth_header_for(u1)
    expect(response).to have_http_status(:ok)

    # ---- pending follow: u4 cannot see u1's friends run (only accepted counts)
    get "/runs/#{r1_friend.id}", headers: auth_header_for(u4)
    expect(response).to have_http_status(:forbidden)

    # ---- rejected follow: u5 cannot see u1's friends run
    get "/runs/#{r1_friend.id}", headers: auth_header_for(u5)
    expect(response).to have_http_status(:forbidden)

    # ---- no follow: u6 cannot see u1's only_me or friends, can see open
    get "/runs/#{r1_only.id}", headers: auth_header_for(u6)
    expect(response).to have_http_status(:forbidden)

    get "/runs/#{r1_friend.id}", headers: auth_header_for(u6)
    expect(response).to have_http_status(:forbidden)

    get "/runs/#{r1_open.id}", headers: auth_header_for(u6)
    expect(response).to have_http_status(:ok)

    # ---- owner always sees own runs (all privacy levels)
    get "/runs/#{r1_only.id}", headers: auth_header_for(u1)
    expect(response).to have_http_status(:ok)

    get "/runs/#{r1_open.id}", headers: auth_header_for(u1)
    expect(response).to have_http_status(:ok)

    get "/runs/#{r1_friend.id}", headers: auth_header_for(u1)
    expect(response).to have_http_status(:ok)
  end
end