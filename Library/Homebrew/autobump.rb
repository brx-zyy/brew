# typed: strict
# frozen_string_literal: true

require "autobump_constants"

# Autobump eligibility for formulae and casks.
module Autobump
  # Recover preset reasons from JSON while preserving custom explanations.
  sig { params(reason: T.any(String, Symbol)).returns(T.any(String, Symbol)) }
  def self.reason_from_api(reason)
    NO_AUTOBUMP_REASONS_LIST.key?(reason.to_sym) ? reason.to_sym : reason
  end

  # Common implementation of the formula and cask autobump exclusion stanza.
  module DSL
    # The reason for a DSL exclusion, if any.
    sig { returns(T.nilable(T.any(String, Symbol))) }
    attr_reader :no_autobump_message

    sig { returns(T::Boolean) }
    def autobump? = no_autobump_message.nil?

    private

    sig { params(because: T.any(String, Symbol), from_metadata: T::Boolean).void }
    def set_no_autobump(because:, from_metadata: false)
      if because.is_a?(Symbol) && !NO_AUTOBUMP_REASONS_LIST.key?(because) && !from_metadata
        Kernel.raise ArgumentError, "'because' argument should use valid symbol or a string!"
      end

      @no_autobump_message = T.let(because, T.nilable(T.any(String, Symbol)))
    end
  end
end
