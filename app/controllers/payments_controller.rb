class PaymentsController < ApplicationController
    def create
        post = Post.find(params[:post_id])
        amount = calculate_amount(post)
        intent = Stripe::PaymentIntent.create(amount: amount, currency: 'usd')
        render json: { client_secret: intent.client_secret }
    end  
    
    def webhook
        payload = request.body.read
        event = Stripe::Event.construct_from(JSON.parse(payload))
        case event.type
        when 'payment_intent.succeeded'
            handle_successful_payment(event.data.object)
        end
        render json: { status: 'success' }
    end
  
    private
    def handle_successful_payment(payment_intent)
        payment_intent_id = payment_intent.id
        # Retrieve post_id and user_id from payment metadata
        post_id = payment_intent.metadata.post_id
        user_id = payment_intent.metadata.user_id
        # Fetch post and user
        post = Post.find(post_id)
        user = User.find(user_id)
  
        if post.accessible?(user)
            render json: { message: 'Payment successful. Enjoy the content!' }
        else
            render json: { message: 'Access denied. You have exceeded your view limit.' }
        end
    end
      
end
